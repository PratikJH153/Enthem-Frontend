import 'package:flutter/material.dart';

class BottomNavButton extends StatelessWidget {
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;
  const BottomNavButton({
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      iconSize: 36,
      color: isSelected ? Colors.white : Colors.grey.shade800,
      icon: Icon(
        isSelected ? selectedIcon : unselectedIcon,
      ),
    );
  }
}
