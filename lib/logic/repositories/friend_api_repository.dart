import 'package:enthem2frontend/logic/contracts/friend_contract.dart';
import 'package:enthem2frontend/logic/provider/friend_api_provider.dart';
import 'package:enthem2frontend/models/friend.dart';

class FriendAPIRepository extends FriendContract {
  final _provider = FriendAPIProvider();

  @override
  void close() {
    return _provider.close();
  }

  @override
  Future<bool> createChat(String userID) async {
    return await _provider.createChat(userID);
  }

  @override
  Future<bool> dislikeFriend(String userID) async {
    return await _provider.dislikeFriend(userID);
  }

  @override
  Future<List<Friend>> foryou(String userID, int offset) async {
    return await _provider.foryou(userID, offset);
  }

  @override
  Future<bool> likeFriend(String userID) async {
    return await _provider.likeFriend(userID);
  }

  @override
  Future<List<Friend>> nearby(String userID, int offset) async {
    return await _provider.nearby(userID, offset);
  }
}

class NetworkError extends Error {}
