import 'package:enthem2frontend/models/error.dart';
import 'package:enthem2frontend/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

enum ErrorState {
  serverError,
  notFoundError,
  authError,
  signInError,
  usernameExists,
  userExists,
  dobWrong,
  ageProblem,
  locationDenied,
  errorLocation,
  interestsNotAdded,
  workingFeature,
  deleteRoomError,
  searchTitleRequired,
  createRoomTitleRequired,
  otherError,
}

ErrorModel getError(ErrorState error) {
  if (error == ErrorState.serverError) {
    return ErrorModel(
      title: "Server issue!",
      des: "There is a problem with the server! Please try again later!",
      status: "failure",
    );
  } else if (error == ErrorState.authError || error == ErrorState.signInError) {
    return ErrorModel(
      title: "Authentication failed!",
      des: "We are unable to log you in! Please try again later!",
      status: "failure",
    );
  } else if (error == ErrorState.notFoundError) {
    return ErrorModel(
      title: "Not Found 404",
      des: "We are unable to find the required! Please try again later!",
      status: "failure",
    );
  } else if (error == ErrorState.ageProblem) {
    return ErrorModel(
      title: "Only 14+ allowed",
      des: "Please try again later!",
      status: "warning",
    );
  } else if (error == ErrorState.dobWrong) {
    return ErrorModel(
      title: "Date of Birth is not correct",
      des: "",
      status: "warning",
    );
  } else if (error == ErrorState.userExists) {
    return ErrorModel(
      title: "This user exists!",
      des: "Please try to sign in",
      status: "warning",
    );
  } else if (error == ErrorState.usernameExists) {
    return ErrorModel(
      title: "Username Exists!",
      des: "The following username exists! Please try with different username",
      status: "warning",
    );
  } else if (error == ErrorState.otherError) {
    return ErrorModel(
      title: "We ran into some issue!",
      des: "Please try again later!",
      status: "failure",
    );
  } else if (error == ErrorState.locationDenied) {
    return ErrorModel(
      title: "Location permissions are denied",
      // Location permissions are permanently denied, we cannot request permissions.
      des: "",
      status: "warning",
    );
  } else if (error == ErrorState.errorLocation) {
    return ErrorModel(
      title: "Location error!",
      des: "We are not able to find location",
      status: "failure",
    );
  } else if (error == ErrorState.interestsNotAdded) {
    return ErrorModel(
      title: "Atleast 5 - 15 interests needed!",
      des: "Please add more interests!",
      status: "failure",
    );
  } else if (error == ErrorState.deleteRoomError) {
    return ErrorModel(
      title: "Sorry, can't remove the room!",
      des: "Please try again later!",
      status: "failure",
    );
  } else if (error == ErrorState.searchTitleRequired) {
    return ErrorModel(
      title: "Title should be atleast 3 characters",
      des: "",
      status: "warning",
    );
  } else if (error == ErrorState.createRoomTitleRequired) {
    return ErrorModel(
      title: "Title should be between 5-60 characters",
      des: "",
      status: "warning",
    );
  } else if (error == ErrorState.workingFeature) {
    return ErrorModel(
      title: "Currently working on this feature!",
      des: "",
      status: "help",
    );
  } else {
    return ErrorModel(
      title: "We ran into some issue!",
      des: "Please try again later!",
      status: "failure",
    );
  }
}

void errorSnackBar({
  required BuildContext context,
  required ErrorState error,
}) {
  final ErrorModel errorModel = getError(error);
  return showSnackBar(
    context: context,
    status: errorModel.status,
    title: errorModel.title,
    des: errorModel.des,
  );
}
