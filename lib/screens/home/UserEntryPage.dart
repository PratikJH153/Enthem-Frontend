// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '/firebase/sign_in_method.dart';
import '/helper/shared_pref.dart';
import '/logic/repositories/user_api_repository.dart';
import '/screens/auth/interests_screen.dart';
import '/screens/auth/onboard_screen.dart';
import '/screens/auth/splash_screen.dart';
import '/screens/home/home_screen.dart';
import '/services/debug_console.dart';
import '/widgets/custom_snackbar.dart';

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
  bool _isUserSignedIn = false;
  bool _isUserRegistered = false;
  bool isLoading = false;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    setState(() {
      isLoading = true;
    });
    await checkAndSetUserStatus();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<bool> userExists(String id) async {
    try {
      final bool data = await _apiRepository.checkUserExists(id);
      return data;
    } catch (err) {
      showSnackBar(
        context: context,
        status: "failure",
        title: "Server issue!",
        des: "Could not connect to the server! Please try again later!",
      );
      rethrow;
    }
  }

  Future<bool> checkInterestsExists(String id) async {
    try {
      final bool data = await _apiRepository.checkInterestsAdded(id);
      return data;
    } catch (err) {
      showSnackBar(
        context: context,
        status: "failure",
        title: "Server issue!",
        des: "Could not connect to the server! Please try again later!",
      );
      rethrow;
    }
  }

  Future<void> checkAndSetUserStatus() async {
    final id = await _authService.getCurrentUserID();
    if (id != null) {
      final isRegistered = await RegisterUser.getBool();
      if (isRegistered != null && isRegistered == true) {
        debugData("Shared Registered", filename);
        setState(() {
          _isUserRegistered = true;
          _isUserSignedIn = true;
        });
      } else {
        final isUser = await userExists(id);
        if (isUser) {
          setState(() {
            _isUserSignedIn = true;
          });
          final isInterestsAdded = await checkInterestsExists(id);
          if (isInterestsAdded) {
            setState(() {
              _isUserRegistered = true;
            });
            await RegisterUser.setBool(true);
          }
        } else {
          await RegisterUser.setBool(false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? (_isUserSignedIn
            ? !_isUserRegistered
                ? const InterestsPage()
                : const HomePage()
            : const OnboardPage())
        : AnimatedContainer(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.linear,
            child: const SplashScreen(),
          );
  }
}
