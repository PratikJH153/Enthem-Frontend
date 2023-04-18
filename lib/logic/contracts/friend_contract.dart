import 'package:enthem2frontend/models/friend.dart';

abstract class FriendContract {
  Future<List<Friend>> recommendFriends(String userID, int offset);
  Future<List<Friend>> findCompatible(String userID, int offset);
  void close();
}
