import 'dart:ui';

import 'package:enthem2frontend/widgets/loading_widget.dart';

import '/firebase/sign_in_method.dart';
import '/interfaces/user.dart';
import '/logic/repositories/user_api_repository.dart';
import '/screens/auth/username_screen.dart';
import '/screens/home/home_screen.dart';
import '/services/debug_console.dart';
import '/widgets/animated_button.dart';
import '/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class OnboardPage extends StatefulWidget {
  static const routeID = "/onboardpage";
  const OnboardPage({super.key});

  static const String filename = "onboard_screen.dart";

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  final UserInterface userModel = UserInterface();
  final AuthService _authService = AuthService();
  final UserAPIRepository _apiRepository = UserAPIRepository();

  late RiveAnimationController _btnAnimationController;
  bool _isLoading = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    _btnAnimationController.dispose();
    super.dispose();
  }

  void signInWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final User user = await _authService.signInGoogle();
      if (context.mounted) {
        final bool isUserExists = await checkUserExists(context, user.uid);
        if (isUserExists) {
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              HomePage.routeID,
              (route) => false,
            );
          } else {
            debugError("Not mounted", OnboardPage.filename);
          }
        } else {
          userModel.id = user.uid;
          userModel.email = user.email;
          userModel.photoURL = user.photoURL;
          debugData(userModel.toString(), OnboardPage.filename);
          if (context.mounted) {
            Navigator.of(context).pushNamed(
              UsernamePage.routeID,
              arguments: userModel,
            );
          } else {
            debugError("Not mounted", OnboardPage.filename);
          }
        }
      }
    } catch (err) {
      showSnackBar(
        context: context,
        status: "failure",
        title: "Something went wrong!",
        des: "Could not sign in through google! Try again later.",
      );
      setState(() {
        _isLoading = false;
      });
      debugError(err.toString(), OnboardPage.filename);
      rethrow;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> checkUserExists(BuildContext context, String uid) async {
    try {
      final bool isUser = await _apiRepository.checkUserExists(uid);
      return isUser;
    } catch (err) {
      showSnackBar(
        context: context,
        status: "failure",
        title: "Something went wrong!",
        des: "Could not sign in through google! Try again later.",
      );
      debugError(err.toString(), OnboardPage.filename);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingWidget();
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Image.asset("assets/Backgrounds/Spline.png"),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const SizedBox(
                    width: 260,
                    child: Column(
                      children: [
                        Text(
                          "Meet learn & start",
                          style: TextStyle(
                            fontSize: 60,
                            fontFamily: "Poppins",
                            height: 1.2,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Onboard with us and discover a community and individuals of like-minded people in your area!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  // BlocConsumer<AuthCubit, AuthState>(
                  //   listener: (context, state) {
                  //     if (state == AuthState.signinError) {}
                  //   },
                  //   builder: (context, state) {
                  //     if (state == AuthState.signingLoading) {
                  //       return const Center(child: LoadingWidget());
                  //     } else {
                  //       return AnimatedButton(
                  //         btnAnimationController: _btnAnimationController,
                  //         onTap: () {
                  //           _btnAnimationController.isActive = true;
                  //           Future.delayed(const Duration(milliseconds: 1200),
                  //               () {
                  //             signInWithGoogle(context);
                  //           });
                  //         },
                  //       );
                  //     }
                  //   },
                  // ),

                  AnimatedButton(
                    btnAnimationController: _btnAnimationController,
                    onTap: () {
                      _btnAnimationController.isActive = true;
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        signInWithGoogle(context);
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "By tapping Sign In and using Enthem, you agree to our Terms and Privacy Policy.",
                    ),
                  )
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: kPagePadding.copyWith(
          //     bottom: 40,
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Expanded(
          //         child: Image.asset(
          //           "assets/images/enthem1.png",
          //           fit: BoxFit.contain,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 30.0,
          //           vertical: 20,
          //         ),
          //         child: Column(
          //           children: [
          //             TextButton(
          //               onPressed: () => signInWithGoogle(context),
          //               style: TextButton.styleFrom(
          //                 backgroundColor: Colors.white,
          //                 padding: const EdgeInsets.symmetric(
          //                   vertical: 10,
          //                 ),
          //               ),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Image.asset(
          //                     "assets/images/google.png",
          //                     height: 30,
          //                     width: 30,
          //                   ),
          //                   const SizedBox(
          //                     width: 10,
          //                   ),
          //                   const Text(
          //                     "Sign in with Google",
          //                     style: TextStyle(
          //                       color: Colors.black,
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //             const SizedBox(
          //               height: 15,
          //             ),
          //             SizedBox(
          //               width: double.infinity,
          //               child: TextButton(
          //                 style: TextButton.styleFrom(
          //                   padding: const EdgeInsets.symmetric(
          //                     vertical: 15,
          //                   ),
          //                   backgroundColor:
          //                       Theme.of(context).scaffoldBackgroundColor,
          //                   shadowColor: Colors.black,
          //                   elevation: 20,
          //                 ),
          //                 onPressed: () {
          //                   showSnackBar(
          //                     context: context,
          //                     status: "help",
          //                     title: "Working on this!",
          //                     des:
          //                         "This feature is coming soon! Stay updated!",
          //                   );
          //                 },
          //                 child: const Text(
          //                   "Sign in with Phone",
          //                   style: TextStyle(
          //                     fontSize: 16,
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(
          //               height: 40,
          //             ),
          //             const Text(
          //               "By tapping Sign In and using Enthem, you agree to our Terms and Privacy Policy.",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w500,
          //                 color: Colors.white70,
          //                 fontSize: 13,
          //                 height: 1.4,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
