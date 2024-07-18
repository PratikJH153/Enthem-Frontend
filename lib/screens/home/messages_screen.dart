import 'package:enthem2/screens/home/home_screen.dart';
import 'package:enthem2/views/working_feature_screen.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  static const routeID = "/messagespage";
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool pop) async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeID, (route) => false);
        return;
      },
      child: const Scaffold(
        body: Center(child: WorkingFeatureScreen()),
      ),
    );
  }
}
