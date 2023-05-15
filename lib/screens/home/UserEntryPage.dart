// ignore_for_file: file_names

import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/logic/provider/global_data_provider.dart';
import 'package:enthem2frontend/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

import '/firebase/sign_in_method.dart';
import '/logic/repositories/user_api_repository.dart';
import '/screens/auth/interests_screen.dart';
import '/screens/auth/onboard_screen.dart';
import '/screens/auth/splash_screen.dart';
import '/screens/home/home_screen.dart';
import '/services/debug_console.dart';

class UserEntryPage extends StatefulWidget {
  static const routeID = "/userentrypage";
  const UserEntryPage({Key? key}) : super(key: key);

  @override
  State<UserEntryPage> createState() => _UserEntryPageState();
}

class _UserEntryPageState extends State<UserEntryPage> {
  static const String filename = "wrapper.dart";
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

  void _initializeProviders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await GlobalDataProvider.initializeProviders(context);
    } on Exception catch (e) {
      debugError(e.toString(), filename);
      showSnackBar(
        context: context,
        status: "failure",
        title: "Server issue!",
        des: "Couldn't connect to the server",
      );
      rethrow;
    }

    setState(() {
      _isLoading = false;
    });
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
          });
          final isUserInterestsRegistered =
              await _apiRepository.checkInterestsAdded(currentUserID);
          if (isUserInterestsRegistered) {
            setState(() {
              _isUserInterestsExists = true;
            });

            _initializeProviders();
          }
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      debugError(err.toString(), filename);
      errorSnackBar(
        context: context,
        error: ErrorState.serverError,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading
        ? (_isUserGoogleSignedIn && _isUserRegistered
            ? _isUserInterestsExists
                ? const HomePage()
                : const InterestsPage()
            : const OnboardPage())
        : AnimatedContainer(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.linear,
            child: const SplashScreen(),
          );
  }
}
