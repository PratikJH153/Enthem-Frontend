import 'package:enthem2/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class DoneButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isDisabled;

  const DoneButton({
    required this.title,
    required this.isDisabled,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Bounce(
        duration: const Duration(milliseconds: 200),
        onPressed: () => isDisabled
            ? null
            : Future.delayed(const Duration(milliseconds: 200), () {
                onTap();
              }),
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
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
              fontFamily: "Grandis Extended",
            ),
          ),
        ),
      ),
    );
  }
}
