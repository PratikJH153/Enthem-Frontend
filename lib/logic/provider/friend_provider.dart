import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enthem2frontend/utils/encryption.dart';
import 'package:enthem2frontend/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import '/constants/constants.dart';
import '/models/friend.dart';
import '/services/api_options.dart';
import '/services/debug_console.dart';
import '../contracts/friend_contract.dart';

class FriendProvider extends ChangeNotifier implements FriendContract {
  final Dio _dio = Dio();
  final String _url = '$baseUrl/user';
  static const String filename = "friend_provider.dart";

  AsyncState nearbyAsyncState = AsyncState.isLoading;
  AsyncState forYouAsyncState = AsyncState.isLoading;

  List<Friend> nearbyList = [];
  List<Friend> forYouList = [];

  @override
  Future<void> nearby(String userID, int offset) async {
    try {
      setNearbyLoading();

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

      nearbyList = recommendList;

      setNearbyLoading(isLoading: false);
    } catch (error) {
      debugError(error.toString(), filename);
      nearbyAsyncState = AsyncState.wentWrong;
      notifyListeners();
      rethrow;
    }
  }

  @override
  Future<void> foryou(String userID, int offset) async {
    try {
      setForYouLoading();

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

      forYouList = recommendList;

      setForYouLoading(isLoading: false);
    } catch (error) {
      debugError(error.toString(), filename);
      forYouAsyncState = AsyncState.wentWrong;
      notifyListeners();
      rethrow;
    }
  }

  void setNearbyLoading({bool isLoading = true}) {
    nearbyAsyncState = isLoading ? AsyncState.isLoading : AsyncState.hasLoaded;
    notifyListeners();
  }

  void setForYouLoading({bool isLoading = true}) {
    forYouAsyncState = isLoading ? AsyncState.isLoading : AsyncState.hasLoaded;
    notifyListeners();
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
