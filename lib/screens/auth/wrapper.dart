import 'package:enthem2frontend/logic/bloc/internet/internet_bloc.dart';
import 'package:enthem2frontend/logic/bloc/internet/internet_state.dart';

import '/screens/home/UserEntryPage.dart';
import '/screens/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetWrapper extends StatefulWidget {
  static const routeID = "/wrapper";

  const InternetWrapper({super.key});

  @override
  State<InternetWrapper> createState() => _InternetWrapperState();
}

class _InternetWrapperState extends State<InternetWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetState>(
      listener: (previous, next) {},
      builder: (context, state) {
        if (state is InternetNotFoundState) {
          return const Scaffold(
            body: Center(
              child: Text("Internet not found!"),
            ),
          );
        }
        if (state is InternetFetchingState) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.linear,
            child: const SplashScreen(),
          );
        }

        if (state is InternetAvailableState) {
          return const UserEntryPage();
        } else {
          return const Text("Something went wrong!");
        }
      },
    );
  }
}
