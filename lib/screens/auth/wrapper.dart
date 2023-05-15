import '/screens/home/UserEntryPage.dart';
import 'package:flutter/material.dart';

class InternetWrapper extends StatefulWidget {
  static const routeID = "/wrapper";

  const InternetWrapper({super.key});

  @override
  State<InternetWrapper> createState() => _InternetWrapperState();
}

class _InternetWrapperState extends State<InternetWrapper> {
  @override
  Widget build(BuildContext context) {
    return const UserEntryPage();
  }
}
