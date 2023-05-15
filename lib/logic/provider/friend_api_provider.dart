import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enthem2frontend/utils/encryption.dart';
import '/constants/constants.dart';
import '/models/friend.dart';
import '/services/api_options.dart';
import '/services/debug_console.dart';
import '../contracts/friend_contract.dart';

class FriendAPIProvider extends FriendContract {
  final Dio _dio = Dio();
  final String _url = '$baseUrl/user';
  static const String filename = "friend_api_provider.dart";

  @override
  Future<List<Friend>> nearby(String userID, int offset) async {
    try {
      final jsonData = {"id": encrypt(userID, env["SECRET_KEY"]!)};
      Response response = await _dio.get(
        "$_url/nearby",
        data: json.encode(jsonData),
        queryParameters: {
          "offset": offset.toString(),
        },
        options: getOptions(),
      );
      final data = json.decode(response.toString());
      final List<Friend> recommendList = [];
      debugData(data["data"], filename);
      data["data"].forEach((e) => recommendList.add(Friend.fromJson(e)));

      return recommendList;
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<List<Friend>> foryou(String userID, int offset) async {
    try {
      final jsonData = {"id": encrypt(userID, env["SECRET_KEY"]!)};
      Response response = await _dio.get(
        "$_url/foryou",
        data: json.encode(jsonData),
        queryParameters: {
          "offset": offset,
        },
        options: getOptions(),
      );
      final data = json.decode(response.toString());
      final List<Friend> recommendList = [];
      debugData(data["data"], filename);
      data["data"].forEach((e) => recommendList.add(Friend.fromJson(e)));

      return recommendList;
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  void close() {
    _dio.close();
  }

  @override
  Future<bool> dislikeFriend(String userID) {
    // TODO: implement dislikeFriend
    throw UnimplementedError();
  }

  @override
  Future<bool> likeFriend(String userID) {
    // TODO: implement likeFriend
    throw UnimplementedError();
  }

  @override
  Future<bool> createChat(String userID) {
    // TODO: implement createChat
    throw UnimplementedError();
  }
}
