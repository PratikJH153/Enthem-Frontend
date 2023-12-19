import 'package:enthem2/models/chat.dart';

abstract class ChatContract {
  Future<List<Chat>> getUserChats();
  Future<bool> createChat(Chat chat);
  Future<bool> blockChat(Chat chat);
  Future<bool> unblockChat(Chat chat);
}
