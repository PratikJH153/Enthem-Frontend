import 'package:dotted_border/dotted_border.dart';
import 'package:enthem2/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FindMoreWidget extends StatelessWidget {
  const FindMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: DottedBorder(
        dashPattern: const [12, 5],
        borderType: BorderType.RRect,
        radius: const Radius.circular(50),
        color: primaryColor,
        strokeWidth: 2,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Color.fromARGB(255, 37, 36, 37),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 10,
                spreadRadius: 0.6,
                offset: Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.person_2_alt,
                size: 60,
              ),
              Text(
                "Find more",
                style: TextStyle(
                  fontFamily: "Exo2",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
