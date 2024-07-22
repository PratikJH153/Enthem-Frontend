// ignore_for_file: file_names

import 'package:enthem2/helper/error_constants.dart';
import 'package:flutter/material.dart';

import '/firebase/sign_in_method.dart';
import '/logic/repositories/user_api_repository.dart';
import '/screens/auth/onboard_screen.dart';
import '/screens/home/home_screen.dart';
import '/services/debug_console.dart';

class UserEntryPage extends StatefulWidget {
  static const routeID = "/userentrypage";
  const UserEntryPage({super.key});

  @override
  State<UserEntryPage> createState() => _UserEntryPageState();
}

class _UserEntryPageState extends State<UserEntryPage> {
  static const String filename = "userEntryPage.dart";
  final AuthService _authService = AuthService();
  final UserAPIRepository _apiRepository = UserAPIRepository();
  bool _isLoading = false;
  bool _isUserRegistered = false;
  bool _isUserGoogleSignedIn = false;
  bool _isUserInterestsExists = false;

  @override
  void initState() {
    checkUserStatus();
    super.initState();
  }

  Future<void> checkUserStatus() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final currentUserID = _authService.getCurrentUserID();
      setState(() {
        _isUserGoogleSignedIn = true;
      });
      if (currentUserID != null) {
        final isUserRegistered =
            await _apiRepository.checkUserExists(currentUserID);
        if (isUserRegistered) {
          setState(() {
            _isUserRegistered = true;
            print("USER CREATED!");
          });
          final isUserInterestsRegistered =
              await _apiRepository.checkInterestsAdded(currentUserID);
          if (isUserInterestsRegistered) {
            setState(() {
              _isUserInterestsExists = true;
              print("INTERESTS CREATED!");
            });
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, HomePage.routeID);
            }
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      debugError(err.toString(), filename);
      if (context.mounted) {
        errorSnackBar(
          context: context,
          error: ErrorState.serverError,
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
  // User entry page is called when the app launches
  // Also when

  @override
  Widget build(BuildContext context) {
    // return !_isLoading
    //     ? (_isUserGoogleSignedIn && _isUserRegistered
    //         ? _isUserInterestsExists
    //             ? const HomePage()
    //             : const InterestsPage()
    //         : const OnboardPage())
    //     : AnimatedContainer(
    //         duration: const Duration(milliseconds: 1500),
    //         curve: Curves.linear,
    //         child: const SplashScreen(),
    //       );
    return const OnboardPage();
  }
}
