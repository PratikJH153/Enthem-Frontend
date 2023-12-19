import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

ContentType getType(String status) {
  switch (status) {
    case "success":
      {
        return ContentType.success;
      }
    case "help":
      {
        return ContentType.help;
      }

    case "failure":
      {
        return ContentType.failure;
      }
    case "warning":
      {
        return ContentType.warning;
      }
    default:
      {
        return ContentType.success;
      }
  }
}

void showSnackBar({
  required BuildContext context,
  required String status,
  required String title,
  required String des,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: des,
      contentType: getType(status),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
