import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LocationNotGivenScreen extends StatelessWidget {
  const LocationNotGivenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: const BorderRadius.all(
        Radius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/images/no_location.json",
            fit: BoxFit.contain,
            reverse: true,
          ),
          const Text(
            "Hey! Please share your location to get better results",
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
            "Update your location in the profile",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
