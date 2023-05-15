import 'package:enthem2frontend/models/message.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/user.dart';

abstract class ChatContract {
  Future<List<UserModel>> getUserChats();
  Future<Room> getRoom(String chatID);
  Future<List<Message>> getMessages(String roomID);
  Future<bool> createChat(Room room);
  Future<bool> sendMessage(Map<String, dynamic> message);
}
