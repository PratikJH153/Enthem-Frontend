import 'package:enthem2/helper/error_constants.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<bool> handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    if (context.mounted) {
      errorSnackBar(context: context, error: ErrorState.locationDenied);
      return false;
    }
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (context.mounted) {
        errorSnackBar(context: context, error: ErrorState.locationDenied);
        return false;
      }
    }
  }
  if (permission == LocationPermission.deniedForever) {
    if (context.mounted) {
      errorSnackBar(context: context, error: ErrorState.locationDenied);
      return false;
    }
  }
  return true;
}
