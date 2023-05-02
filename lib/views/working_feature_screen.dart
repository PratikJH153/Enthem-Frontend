import 'package:enthem2frontend/constants/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WorkingFeatureScreen extends StatelessWidget {
  const WorkingFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: kPagePadding.copyWith(
          bottom: 100,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/images/working.json",
              height: 300,
              width: 300,
            ),
            const Text(
              "Currently working on this feature!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Stay tuned for upcoming new features!",
            ),
          ],
        ),
      ),
    );
  }
}
