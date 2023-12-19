import 'package:enthem2/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class AuthContinueButton extends StatelessWidget {
  final String? des;
  final VoidCallback onTap;
  final bool isDisabled;
  final String title;

  const AuthContinueButton({
    this.des,
    required this.isDisabled,
    required this.onTap,
    this.title = "Continue",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 32,
        right: 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            des ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white54,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Bounce(
            duration: const Duration(milliseconds: 200),
            onPressed: () => isDisabled
                ? null
                : Future.delayed(
                    const Duration(milliseconds: 200),
                    () {
                      onTap();
                    },
                  ),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: isDisabled ? buttonColor.withOpacity(0.5) : buttonColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: "Grandis Extended",
                    ),
                  ),
                  const Icon(
                    Icons.arrow_right_alt_rounded,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
