import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enthem2frontend/constants/constants.dart';
import 'package:enthem2frontend/database/contracts/chat_contract.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/message.dart';
import 'package:enthem2frontend/services/api_options.dart';
import 'package:enthem2frontend/services/debug_console.dart';

class ChatAPIProvider implements ChatContract {
  final Dio _dio = Dio();
  final String _url = '$baseUrl/chat';
  static const String filename = "chat_api_provider.dart";

  @override
  Future<bool> createChat(Room room) async {
    try {
      final jsonData = room.toJson();
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
  Future<List<Message>> getMessages(String roomID) {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  Future<Room> getRoom(String chatID) {
    // TODO: implement getRoom
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getUserChats() {
    // TODO: implement getUserChats
    throw UnimplementedError();
  }

  @override
  Future<bool> sendMessage(Map<String, dynamic> message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
