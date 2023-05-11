abstract class FriendContract {
  Future<void> getNearby(String userID, int offset);
  Future<void> getForYou(String userID, int offset);
  void close();
}
