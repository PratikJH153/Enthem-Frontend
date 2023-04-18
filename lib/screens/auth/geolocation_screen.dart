import 'package:enthem2frontend/constants/page_padding.dart';
import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/interfaces/user.dart';
import 'package:enthem2frontend/logic/repositories/user_api_repository.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/screens/auth/interests_screen.dart';
import 'package:enthem2frontend/screens/home/home_screen.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/utils/location_permission.dart';
import 'package:enthem2frontend/widgets/auth_continue_button.dart';
import 'package:enthem2frontend/widgets/loading_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocationPage extends StatefulWidget {
  static const routeID = "/geolocationpage";

  final UserInterface userInterface;

  const GeoLocationPage({
    required this.userInterface,
    super.key,
  });

  @override
  State<GeoLocationPage> createState() => _GeoLocationPageState();
}

class _GeoLocationPageState extends State<GeoLocationPage> {
  Position? _currentPosition;
  bool _isLoading = false;
  static const String filename = "geolocation_screen.dart";

  final UserAPIRepository _apiRepository = UserAPIRepository();

  void navigateToHomePage() async {
    widget.userInterface.latitude = _currentPosition!.latitude;
    widget.userInterface.longitude = _currentPosition!.longitude;
    await registerUser();
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      _isLoading = true;
    });
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    }).catchError((e) {
      debugError(e.toString(), filename);
      errorSnackBar(context: context, error: ErrorState.errorLocation);
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> registerUser() async {
    try {
      final UserModel userModel = UserModel.fromInterface(widget.userInterface);
      final int isUserRegistered = await _apiRepository.registerUser(
        userModel,
      );
      final bool isUserSQLRegistered =
          await _apiRepository.registerUserSQL(userModel);
      if (context.mounted) {
        if (isUserRegistered == 200) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const InterestsPage(),
            ),
            (route) => false,
          );
        } else if (isUserRegistered == 409 && isUserSQLRegistered) {
          errorSnackBar(context: context, error: ErrorState.userExists);
          Future.delayed(
              const Duration(
                seconds: 1,
              ), () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            );
          });
        } else {
          debugError("User not created!", "geolocation_screen.dart");
          errorSnackBar(context: context, error: ErrorState.serverError);
        }
      }
    } catch (err) {
      debugError(err.toString(), filename);
      errorSnackBar(context: context, error: ErrorState.serverError);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: registerUser,
            child: const Text("Skip"),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AuthContinueButton(
        isDisabled: _currentPosition == null,
        onTap: navigateToHomePage,
        des:
            "We do not track your location in any way. Your city is used to find relevant people.",
      ),
      body: SafeArea(
        child: Padding(
          padding: kPagePadding.copyWith(
            top: 20,
            left: 35,
            right: 35,
            bottom: 100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose location",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "Give us your location to connect with relevant people with you",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: _isLoading
                    ? const LoadingWidget()
                    : InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        onTap: _isLoading ? null : _getCurrentPosition,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              Lottie.asset(
                                "assets/images/lottie.json",
                                height: 150,
                                width: 150,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                _currentPosition == null
                                    ? "Location Access Required"
                                    : "Thank you for sharing us the location!\n",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              _currentPosition != null
                                  ? const SizedBox()
                                  : const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        "Enthem works by showing you\nrooms and like-minded people around you, so you need to enable location access to continue.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
