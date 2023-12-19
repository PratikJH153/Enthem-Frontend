import 'package:dio/dio.dart';
import 'package:enthem2/constants/constants.dart';

Options getOptions() {
  return Options(
    headers: {
      "Authorization": env["BEARER_TOKEN"],
    },
    responseType: ResponseType.json,
    contentType: "application/json",
    followRedirects: false,
    validateStatus: (status) {
      return status! <= 500;
    },
  );
}
