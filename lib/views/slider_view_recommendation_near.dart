import 'package:enthem2frontend/logic/bloc/friend/near_you_bloc.dart';
import 'package:enthem2frontend/logic/bloc/friend/near_you_state.dart';
import 'package:enthem2frontend/views/location_not_given_view.dart';

import '/widgets/carousal.dart';
import '/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SliderViewRecommendationNear extends StatefulWidget {
  final String userID;
  final bool isLocationGiven;
  const SliderViewRecommendationNear({
    required this.userID,
    required this.isLocationGiven,
    super.key,
  });

  @override
  State<SliderViewRecommendationNear> createState() =>
      _SliderViewRecommendationNearState();
}

class _SliderViewRecommendationNearState
    extends State<SliderViewRecommendationNear> {
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
    return BlocConsumer<NearYouBloc, NearYouState>(
        listener: (previous, next) {},
        builder: (context, state) {
          if (state is NearYouLoadingState) {
            return const Center(
              child: LoadingWidget(),
            );
          }

          if (state is NearYouFailedState) {
            return const Center(
              child: Text("Oops! Something went wrong!"),
            );
          }

          List friends = [];
          if (state is NearYouFetchedState) {
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
        });
  }
}
