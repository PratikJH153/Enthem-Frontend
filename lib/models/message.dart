class Message {
  final String type;
  final String msg;
  final String sender;
  final DateTime timestamp;

  Message({
    required this.type,
    required this.msg,
    required this.sender,
    required this.timestamp,
  });
}
