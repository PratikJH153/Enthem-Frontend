class Message {
  final String type;
  final String msg;
  final String sender;
  final DateTime timestamp;
  final bool isUserJoinedOrLeftMessage;

  Message({
    required this.type,
    required this.msg,
    required this.sender,
    required this.timestamp,
    this.isUserJoinedOrLeftMessage = false,
  });
}
