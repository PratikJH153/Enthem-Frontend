import 'package:enthem2frontend/models/friend.dart';

abstract class FriendContract {
  Future<List<Friend>> nearby(String userID, int offset);
  Future<List<Friend>> foryou(String userID, int offset);
  Future<bool> likeFriend(String userID);
  Future<bool> dislikeFriend(String userID);
  Future<bool> createChat(String userID);
  void close();
}
