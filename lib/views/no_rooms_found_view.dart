import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoRoomsFoundScreen extends StatelessWidget {
  final VoidCallback onTap;
  const NoRoomsFoundScreen({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              "assets/images/rocket.json",
              height: 200,
              width: 200,
            ),
            const Text(
              "Oops! There are no rooms near you",
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
              "Create a room",
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "OR",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: onTap,
              child: const Text(
                "Search more",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
