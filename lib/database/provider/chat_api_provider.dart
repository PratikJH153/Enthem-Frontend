import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enthem2/constants/constants.dart';
import 'package:enthem2/database/contracts/chat_contract.dart';
import 'package:enthem2/logic/provider/user_api_provider.dart';
import 'package:enthem2/models/chat.dart';
import 'package:enthem2/services/api_options.dart';
import 'package:enthem2/services/debug_console.dart';

class ChatAPIProvider implements ChatContract {
  final Dio _dio = Dio();
  final String _url = '$baseUrl/chat';
  static const String filename = "chat_api_provider.dart";

  final UserAPIProvider _userAPIProvider = UserAPIProvider();

  @override
  Future<List<Chat>> getUserChats() async {
    try {
      final jsonData = {"uid": _userAPIProvider.getUserID()};
      Response response = await _dio.get(
        _url,
        data: json.encode(jsonData),
        options: getOptions(),
      );
      final data = json.decode(response.toString());
      debugData(data["data"], filename);
      final List<Chat> chatsList = [];
      data["data"].forEach((chat) => chatsList.add(Chat.fromJson(chat)));
      return chatsList;
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<bool> createChat(Chat chat) async {
    try {
      final jsonData = chat.toJson();
      Response response = await _dio.post(
        _url,
        data: json.encode(jsonData),
        options: getOptions(),
      );
      final data = json.decode(response.toString());
      debugData(data["data"], filename);

      return data["data"];
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<bool> blockChat(Chat chat) {
    // TODO: implement blockChat
    throw UnimplementedError();
  }

  @override
  Future<bool> unblockChat(Chat chat) {
    // TODO: implement unblockChat
    throw UnimplementedError();
  }
}
