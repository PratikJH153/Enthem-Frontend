import 'package:enthem2frontend/theme/theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const PrimaryButton({
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        iconSize: 23,
        backgroundColor: buttonColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
      onPressed: onTap,
      icon: Icon(
        icon,
      ),
    );
  }
}
