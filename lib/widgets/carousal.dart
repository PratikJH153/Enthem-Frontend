import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/models/friend.dart';
import 'package:enthem2frontend/theme/theme.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

Widget carouselView(PageController pageController, int index, Widget widget) {
  return AnimatedBuilder(
    animation: pageController,
    builder: (context, child) {
      double value = 0.0;
      if (pageController.position.haveDimensions) {
        value = index.toDouble() - (pageController.page ?? 0);
        value = (value * 0.038).clamp(-1, 1);
      }
      return Transform.rotate(
        angle: pi * value,
        child: widget,
      );
    },
  );
}

Widget carouselCard(
  Friend data,
  BuildContext context,
) {
  return Column(
    children: <Widget>[
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Hero(
                  tag: data.photoURL,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white10,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Colors.black26,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${data.username[0].toUpperCase()}${data.username[data.username.length - 1].toUpperCase()}",
                        style: const TextStyle(
                          fontSize: 70,
                          fontFamily: "Poppins",
                        ),
                      ),
                      // child: ClipRRect(
                      //   borderRadius: const BorderRadius.only(
                      //     topLeft: Radius.circular(30),
                      //     topRight: Radius.circular(30),
                      //   ),
                      //   child: Image.network(
                      //     data.photoURL,
                      //     fit: BoxFit.cover,
                      //     errorBuilder: (context, exception, stackTrace) {
                      //       return Image.asset("assets/images/dummy.png");
                      //     },
                      //   ),
                      // ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${data.age}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${data.distance.toStringAsFixed(2)} mil",
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Compatible"),
                        Text("${data.compatible.toString()}%")
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7.0),
                      child: LinearPercentIndicator(
                        lineHeight: 3,
                        barRadius: const Radius.circular(10),
                        padding: const EdgeInsets.all(0),
                        percent: data.compatible / 100,
                        progressColor: primaryColor,
                        backgroundColor: Colors.black38,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            errorSnackBar(
                              context: context,
                              error: ErrorState.workingFeature,
                            );
                          },
                          child: const Icon(CupertinoIcons.flame),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            errorSnackBar(
                              context: context,
                              error: ErrorState.workingFeature,
                            );
                          },
                          child: const Icon(CupertinoIcons.chat_bubble_fill),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
