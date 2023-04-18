import 'package:flutter/foundation.dart';

void debugData(
  dynamic data,
  String filename,
) {
  if (kDebugMode) {
    print("✅✅ Data in $filename ✅✅ ${data.toString()}");
  }
}

void debugError(
  String error,
  String filename,
) {
  if (kDebugMode) {
    print("❌❌ ERROR in $filename ❌❌ $error");
  }
}
