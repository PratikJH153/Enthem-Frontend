import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const String routeID = "/splashpage";
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/enthem1.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
