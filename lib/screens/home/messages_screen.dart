import 'package:enthem2frontend/views/working_feature_screen.dart';
import 'package:flutter/cupertino.dart';
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.question_circle_fill,
              size: 30,
            ),
          ),
        ],
      ),
      body: const WorkingFeatureScreen(),
    );
  }
}
