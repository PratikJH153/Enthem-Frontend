import '../logic/provider/friend_provider.dart';
import '../widgets/loading_widget.dart';
import '/models/friend.dart';
import '/widgets/carousal.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SliderViewRecommendationForYou extends StatefulWidget {
  final String userID;
  final bool isLocationGiven;

  const SliderViewRecommendationForYou({
    required this.userID,
    required this.isLocationGiven,
    super.key,
  });

  @override
  State<SliderViewRecommendationForYou> createState() =>
      _SliderViewRecommendationForYouState();
}

class _SliderViewRecommendationForYouState
    extends State<SliderViewRecommendationForYou> {
  late List<Friend> friends;
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FriendProvider provider = context.watch<FriendProvider>();
    List friends = provider.forYouList;

    if (provider.forYouAsyncState == AsyncState.isLoading) {
      return const LoadingWidget();
    }

    if (provider.forYouAsyncState == AsyncState.wentWrong) {
      return const WentWrongPage();
    }

    return AspectRatio(
      aspectRatio: 0.85,
      child: PageView.builder(
        itemCount: friends.length + 1,
        physics: const ClampingScrollPhysics(),
        controller: _pageController,
        itemBuilder: (context, index) {
          return carouselView(
            _pageController,
            index,
            index < friends.length
                ? carouselCard(
                    friends[index],
                    context,
                    showMiles: widget.isLocationGiven,
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      child: Lottie.asset(
                        "assets/images/find.json",
                        fit: BoxFit.contain,
                        reverse: true,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
