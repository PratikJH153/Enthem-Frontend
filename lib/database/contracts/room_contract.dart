import 'package:enthem2frontend/models/room.dart';

abstract class RoomContract {
  Future<String> addRoom(Room room);
  Future<Room> getRoom(String id);
  Future<List<Room>> getAllRooms({
    required double miles,
    required List<double> coordinates,
  });
  Future<List<Room>> getRoomsByOwnerID({required String ownerID});
  void close();
}
