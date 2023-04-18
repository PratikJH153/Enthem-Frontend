import 'package:flutter/material.dart';

class ExploreInterestWidget extends StatelessWidget {
  final IconData iconData;
  final String title;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  const ExploreInterestWidget({
    required this.iconData,
    required this.title,
    required this.isSelected,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.only(
        right: 8,
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.white : Colors.white12,
        ),
        onPressed: onTap,
        icon: Icon(
          iconData,
          color: color,
          size: 20,
        ),
        label: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
