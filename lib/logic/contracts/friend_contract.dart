abstract class FriendContract {
  Future<void> nearby(String userID, int offset);
  Future<void> foryou(String userID, int offset);
  Future<bool> likeFriend(String userID);
  Future<bool> dislikeFriend(String userID);
  Future<void> createChat(String user1ID, String user2ID);
  void close();
}
