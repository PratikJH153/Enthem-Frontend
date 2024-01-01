import 'package:enthem2/logic/contracts/friend_contract.dart';
import 'package:enthem2/models/friend.dart';

class FriendAPIRepository extends FriendContract {
  final _provider = FriendAPIRepository();

  @override
  void close() {
    return _provider.close();
  }

  @override
  Future<void> createChat(String user1ID, String user2ID) async {
    return await _provider.createChat(user1ID, user2ID);
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
