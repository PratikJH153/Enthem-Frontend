import 'package:flutter/material.dart';

enum AsyncState {
  isLoading,
  hasLoaded,
  wentWrong
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 247, 247),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ]),
        child: const CircularProgressIndicator(
          strokeWidth: 3,
          backgroundColor: Colors.black12,
          color: Color.fromARGB(255, 120, 152, 255),
        ),
      ),
    );
  }
}

class WentWrongPage extends StatelessWidget {
  const WentWrongPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Something went wrong!"),
      ),
    );
  }
}
