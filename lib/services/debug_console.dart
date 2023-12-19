import 'package:enthem2/constants/constants.dart';
import 'package:flutter/foundation.dart';

void debugData(
  dynamic data,
  String filename,
) {
  if (!kProdMode) {
    if (kDebugMode) {
      print("✅✅ Data in $filename ✅✅ ${data.toString()}");
    }
  }
}

void debugError(
  String error,
  String filename,
) {
  if (!kProdMode) {
    if (kDebugMode) {
      print("❌❌ ERROR in $filename ❌❌ $error");
    }
  }
}
