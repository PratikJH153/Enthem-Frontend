import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enthem2frontend/constants/constants.dart';
import 'package:enthem2frontend/database/contracts/room_contract.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/services/api_options.dart';
import 'package:enthem2frontend/services/debug_console.dart';

class RoomAPIProvider extends RoomContract {
  final Dio _dio = Dio();
  final String _url = '$baseUrl/room';
  static const String filename = "room_api_provider.dart";

  @override
  Future<String> addRoom(Room room) async {
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
  Future<Room> getRoom(String id) async {
    try {
      final jsonData = {"id": id};
      Response response = await _dio.get(
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
  void close() {
    _dio.close();
  }

  @override
  Future<List<Room>> getAllRooms({
    required double miles,
    required List<double> coordinates,
  }) async {
    try {
      final jsonData = {"miles": miles, "coordinates": coordinates};
      Response response = await _dio.get(
        "$_url/all",
        data: json.encode(jsonData),
        options: getOptions(),
      );
      final data = json.decode(response.toString());
      debugData(data["data"], filename);
      final List<Room> roomsList = [];
      data["data"].forEach((room) => roomsList.add(Room.fromJson(room)));
      return roomsList;
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<List<Room>> getRoomsByOwnerID({required String ownerID}) async {
    try {
      final jsonData = {"ownerID": ownerID};
      Response response = await _dio.get(
        "$_url/owner",
        data: json.encode(jsonData),
        options: getOptions(),
      );
      final data = json.decode(response.toString());
      debugData(data["data"], filename);
      final List<Room> roomsList = [];
      data["data"].forEach((room) => roomsList.add(Room.fromJson(room)));
      return roomsList;
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }
}
