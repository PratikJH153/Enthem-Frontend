import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Chat extends Equatable {
  final String chatID;
  final String user1ID;
  final String user2ID;
  bool? isDisabled;
  final String messagesID;
  final DateTime createdAt;

  Chat({
    required this.chatID,
    required this.user1ID,
    required this.user2ID,
    this.isDisabled = false,
    required this.messagesID,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Chat: {id: $chatID, user1ID: $user1ID, user2ID: $user2ID, createdAt: $createdAt, isDisabled: $isDisabled, messagesID: $messagesID}';
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    final Chat chat = Chat(
      chatID: json["_id"],
      user1ID: json["user1ID"],
      user2ID: json["user2ID"],
      isDisabled: json["isDisabled"],
      createdAt: DateTime.parse(json["createdAt"]),
      messagesID: json["messagesID"],
    );
    return chat;
  }

  Map<String, dynamic> toJson() {
    final userMap = {
      "chatID": chatID,
      "user1ID": user1ID,
      "user2ID": user2ID,
      "isDisabled": isDisabled,
      "createdAt": createdAt.toString(),
      "messagesID": messagesID,
    };
    return userMap;
  }

  @override
  List<Object?> get props => [
        chatID,
        user1ID,
        user2ID,
        isDisabled,
        createdAt,
        messagesID,
      ];
}
