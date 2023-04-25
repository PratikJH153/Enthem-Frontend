import 'package:enthem2frontend/database/provider/room_api_provider.dart';
import 'package:enthem2frontend/models/room.dart';

import '../contracts/room_contract.dart';

class RoomAPIRepository extends RoomContract {
  final _provider = RoomAPIProvider();

  @override
  Future<String> addRoom(Room room) {
    return _provider.addRoom(room);
  }

  @override
  Future<Room> getRoom(String id) {
    return _provider.getRoom(id);
  }

  @override
  void close() {
    return _provider.close();
  }

  @override
  Future<List<Room>> getAllRooms({
    required double miles,
    required List<double> coordinates,
    required int page,
  }) {
    return _provider.getAllRooms(
        miles: miles, coordinates: coordinates, page: page);
  }

  @override
  Future<List<Room>> getPopularRooms({required int page}) {
    return _provider.getPopularRooms(page: page);
  }

  @override
  Future<List<Room>> getRoomsByOwnerID({required String ownerID}) {
    return _provider.getRoomsByOwnerID(ownerID: ownerID);
  }

  @override
  Future<bool> deleteRoom({required String roomID, required String ownerID}) {
    return _provider.deleteRoom(roomID: roomID, ownerID: ownerID);
  }

  @override
  Future<List<Room>> searchRooms({required String searchString}) {
    return _provider.searchRooms(searchString: searchString);
  }

  @override
  Future<Room> getIntroduceRoom() {
    return _provider.getIntroduceRoom();
  }
}

class NetworkError extends Error {}
