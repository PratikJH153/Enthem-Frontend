import 'package:flutter/material.dart';

enum Gender { male, female, others }

class GenderWidget extends StatelessWidget {
  final VoidCallback onclick;
  final String title;
  final IconData icon;

  final bool isSelected;

  const GenderWidget({
    super.key,
    required this.isSelected,
    required this.onclick,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onclick,
        icon: Icon(
          icon,
          size: 40,
        ),
        label: Text(title),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 20,
          ),
          alignment: Alignment.topLeft,
          textStyle: const TextStyle(
            fontFamily: "Exo2",
            fontSize: 22,
            color: Colors.white,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          side: BorderSide(
            width: 1,
            color: isSelected ? Colors.white : Colors.white12,
          ),
        ),
      ),
    );
  }
}
