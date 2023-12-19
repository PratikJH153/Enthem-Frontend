import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enthem2/constants/constants.dart';
import 'package:enthem2/database/contracts/room_contract.dart';
import 'package:enthem2/models/room.dart';
import 'package:enthem2/services/api_options.dart';
import 'package:enthem2/services/debug_console.dart';

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
      final jsonData = {"uid": id};
      Response response = await _dio.get(
        _url,
        data: json.encode(jsonData),
        options: getOptions(),
      );
      final data = json.decode(response.toString());
      debugData(data["data"], filename);

      return Room.fromJson(data["data"]);
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
    required int page,
  }) async {
    try {
      final jsonData = {"miles": miles, "coordinates": coordinates};
      Response response = await _dio.get(
        "$_url/all?page=$page",
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
  Future<List<Room>> getPopularRooms({required int page}) async {
    try {
      Response response = await _dio.get(
        "$_url/popular?page=$page",
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

  @override
  Future<bool> deleteRoom({
    required String roomID,
    required String ownerID,
  }) async {
    try {
      final jsonData = {
        "roomID": roomID,
        "ownerID": ownerID,
      };
      Response response = await _dio.delete(
        "$_url/",
        data: json.encode(jsonData),
        options: getOptions(),
      );
      debugData(response.statusCode, filename);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<List<Room>> searchRooms({required String searchString}) async {
    try {
      final jsonData = {
        "title": searchString,
      };
      Response response = await _dio.get(
        "$_url/search",
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
  Future<Room> getIntroduceRoom() async {
    try {
      Response response = await _dio.get(
        "$_url/introduce",
        options: getOptions(),
      );
      final data = json.decode(response.toString());
      debugData(data["data"], filename);

      return Room.fromJson(data["data"]);
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }
}
