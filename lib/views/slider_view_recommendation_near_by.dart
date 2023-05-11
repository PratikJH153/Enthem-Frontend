import '../widgets/loading_widget.dart';
import '/logic/provider/friend_provider.dart';
import '/views/location_not_given_view.dart';
import '/widgets/carousal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SliderViewRecommendationNearBy extends StatefulWidget {
  final String userID;
  final bool isLocationGiven;

  const SliderViewRecommendationNearBy({
    required this.userID,
    required this.isLocationGiven,
    super.key,
  });

  @override
  State<SliderViewRecommendationNearBy> createState() =>
      _SliderViewRecommendationNearByState();
}

class _SliderViewRecommendationNearByState
    extends State<SliderViewRecommendationNearBy> {
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
    List friends = provider.nearbyList;

    if (provider.nearbyAsyncState == AsyncState.isLoading) {
      return const LoadingWidget();
    }

    if (provider.nearbyAsyncState == AsyncState.wentWrong) {
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
            !widget.isLocationGiven
                ? const LocationNotGivenScreen()
                : index < friends.length
                    ? carouselCard(
                        friends[index],
                        context,
                        showCompatible: false,
                      )
                    : InkWell(
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
          );
        },
      ),
    );
  }
}
