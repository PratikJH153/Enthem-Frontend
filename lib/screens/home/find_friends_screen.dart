import 'package:enthem2frontend/logic/bloc/friend/for_you_bloc.dart';
import 'package:enthem2frontend/logic/bloc/friend/near_you_bloc.dart';
import 'package:enthem2frontend/screens/home/home_screen.dart';

import '/constants/page_padding.dart';
import '/models/user.dart';
import '/views/slider_view_recommendation.dart';
import '/views/slider_view_recommendation_near.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FindFriendsPage extends StatefulWidget {
  static const routeID = "/findfriendspage";
  final UserModel? user;

  const FindFriendsPage({
    this.user,
    super.key,
  });

  @override
  State<FindFriendsPage> createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  late final PageController _pageController;
  int pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void bottomTapped(int index) {
    setState(() {
      pageIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeID, (route) => false);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: kPagePadding.copyWith(
              left: 0,
              right: 0,
              top: 20,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            pageIndex == 0 ? Colors.white : Colors.white38,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Exo2",
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        bottomTapped(0);
                      },
                      child: const Text("For you"),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            pageIndex == 1 ? Colors.white : Colors.white38,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Exo2",
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        bottomTapped(1);
                      },
                      child: const Text("Nearby"),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    allowImplicitScrolling: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      BlocProvider<ForYouBloc>(
                        create: (_) => ForYouBloc(),
                        child: SliderViewRecommendation(
                          userID: widget.user!.id!,
                          isLocationGiven: widget.user!.isLocationGiven,
                        ),
                      ),
                      BlocProvider<NearYouBloc>(
                        create: (_) => NearYouBloc(),
                        child: SliderViewRecommendationNear(
                          userID: widget.user!.id!,
                          isLocationGiven: widget.user!.isLocationGiven,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(
                //     vertical: 20,
                //     horizontal: 30,
                //   ),
                //   child: Text(
                //     "Every great person should be met with another",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
