import 'package:flutter/material.dart';

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  final List<String> selectedInterest;
  const FilterChipWidget(
      {required this.chipName, required this.selectedInterest, super.key});

  @override
  State<FilterChipWidget> createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: const TextStyle(
        color: Color(0xff6200ee),
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
      selected: _isSelected,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      backgroundColor: const Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
          widget.selectedInterest.add(widget.chipName);
        });
      },
      selectedColor: const Color(0xffeadffd),
      checkmarkColor: Colors.black,
    );
  }
}
