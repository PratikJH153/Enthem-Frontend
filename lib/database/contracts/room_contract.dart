import 'package:enthem2/models/room.dart';

abstract class RoomContract {
  Future<String> addRoom(Room room);
  Future<Room> getRoom(String id);
  Future<Room> getIntroduceRoom();
  Future<List<Room>> getAllRooms(
      {required double miles,
      required List<double> coordinates,
      required int page});
  Future<List<Room>> getPopularRooms({required int page});
  Future<List<Room>> getRoomsByOwnerID({required String ownerID});
  Future<bool> deleteRoom({required String roomID, required String ownerID});
  Future<List<Room>> searchRooms({required String searchString});
  void close();
}
