import 'package:flutter/material.dart';

TextField dobField({
  required TextEditingController controller,
  required int max,
  required String hintText,
  required Function onTap,
}) {
  return TextField(
    controller: controller,
    textAlign: TextAlign.center,
    cursorColor: Colors.white,
    style: const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w600,
    ),
    maxLength: max,
    textCapitalization: TextCapitalization.words,
    decoration: InputDecoration(
      border: InputBorder.none,
      counterText: "",
      hintStyle: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        color: Colors.white38,
      ),
      hintText: hintText,
    ),
    onChanged: (val) => onTap(val),
  );
}
