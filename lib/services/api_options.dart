import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Options getOptions() {
  return Options(
    headers: {
      "Authorization": dotenv.env["BEARER_TOKEN"],
    },
    responseType: ResponseType.json,
    contentType: "application/json",
    followRedirects: false,
    validateStatus: (status) {
      return status! <= 500;
    },
  );
}
