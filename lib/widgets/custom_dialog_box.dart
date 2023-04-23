import 'package:flutter/material.dart';
import 'dialog_box_widget.dart';

Future<dynamic> showCustomDialog(
    BuildContext context, DialogBoxWidget dialogBoxWidget) {
  // showGeneralDialog(
  //   context: context,
  //   barrierLabel: "Barrier",
  //   barrierDismissible: true,
  //   barrierColor: Colors.black.withOpacity(0.5),
  //   transitionDuration: const Duration(milliseconds: 400),
  //   pageBuilder: (_, __, ___) {
  //     return const AreYouSureWidget();
  //   },
  //   transitionBuilder: (_, anim, __, child) {
  //     Tween<Offset> tween;
  //     if (anim.status == AnimationStatus.reverse) {
  //       tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
  //     } else {
  //       tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
  //     }

  //     return SlideTransition(
  //       position: tween.animate(anim),
  //       child: FadeTransition(
  //         opacity: anim,
  //         child: child,
  //       ),
  //     );
  //   },
  // );
  return showDialog(
    context: context,
    builder: (context) {
      return dialogBoxWidget;
    },
  );
}
