import 'package:enthem2frontend/logic/bloc/friend/for_you_bloc.dart';
import 'package:enthem2frontend/logic/bloc/friend/for_you_state.dart';

import '/models/friend.dart';
import '/widgets/carousal.dart';
import '/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class SliderViewRecommendation extends StatefulWidget {
  final String userID;
  final bool isLocationGiven;

  const SliderViewRecommendation({
    required this.userID,
    required this.isLocationGiven,
    super.key,
  });

  @override
  State<SliderViewRecommendation> createState() =>
      _SliderViewRecommendationState();
}

class _SliderViewRecommendationState extends State<SliderViewRecommendation> {
  late List<Friend> friends;
  late final PageController _pageController;
  static const String filename = "slider_view_recommendation.dart";

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
    return BlocConsumer<ForYouBloc, ForYouState>(
        listener: (previous, current) {},
        buildWhen: (previous, current) {
          bool isFetched =
              previous is ForYouFetchedState && current is ForYouFetchedState;
          if (!isFetched) {
            return true;
          }

          bool isDifferent =
              (previous).friendsList.toSet() == (current).friendsList.toSet();
          return !isDifferent;
        },
        builder: (context, state) {
          if (state is ForYouLoadingState) {
            return const Center(
              child: LoadingWidget(),
            );
          }

          if (state is ForYouFailedState) {
            return const Center(child: Text("Oops, something went wrong!"));
          }

          if (state is ForYouFetchedState) {
            friends = state.friendsList;
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
        });
  }
}
