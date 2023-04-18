import 'package:enthem2frontend/constants/constants.dart';
import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/models/message.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/widgets/other_message_widget.dart';
import 'package:enthem2frontend/widgets/own_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatPage extends StatefulWidget {
  final UserModel? user;
  final Room room;
  final String distance;
  const ChatPage({
    Key? key,
    this.user,
    required this.room,
    required this.distance,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late io.Socket? socket;
  final TextEditingController _messageController = TextEditingController();
  List<Message> messagesList = [];

  @override
  void initState() {
    connect();
    super.initState();
  }

  void connect() {
    try {
      socket = io.io(
        socketUrl,
        <String, dynamic>{
          "transports": ["websocket"],
          "autoConnect": false,
          "enableLogging": true,
        },
      );
      socket!.connect();
      socket!.onConnect((_) {
        socket!.emit("joinRoom", {
          "id": widget.room.id,
          "memberID": widget.user!.id,
        });
        socket!.on("sendMsgServer", (msg) {
          setState(() {
            messagesList.add(
              Message(
                type: "msg",
                msg: msg["content"],
                sender: msg["senderChatID"],
                timestamp: msg["timestamp"],
              ),
            );
          });
        });
      });
    } catch (err) {
      debugError(err.toString(), "chat_page.dart");
      rethrow;
    }
  }

  @override
  void dispose() {
    Map<String, dynamic> data = {
      "roomID": widget.room.id,
      "memberID": widget.user!.id
    };
    socket!.emit("removeMember", data);
    socket!.disconnect();
    socket!.close();
    socket!.destroy();
    socket!.dispose();
    super.dispose();
  }

  void sendMessage(
    String msg,
    String sender,
  ) {
    Message message = Message(
      type: "ownMsg",
      msg: msg,
      sender: sender,
      timestamp: DateTime.now(),
    );
    setState(() {
      messagesList.add(message);
    });
    socket!.emit(
      "sendMsg",
      {
        'content': msg,
        'senderChatID': widget.user!.id!,
        'receiverChatID': widget.room.id!,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => RoomSettings(
              //       room: widget.room,
              //       distance: widget.distance,
              //       userID: widget.user!.id!,
              //     ),
              //   ),
              // );
              errorSnackBar(
                context: context,
                error: ErrorState.workingFeature,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.room.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: "Exo2"),
                ),
                const Text(
                  "Tap for group info",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messagesList.length,
              reverse: true,
              itemBuilder: ((context, index) {
                final messages = messagesList.reversed.toList();
                return messages[index].type == "ownMsg"
                    ? OwnMessageWidget(
                        msg: messages[index].msg,
                        sender: messages[index].sender,
                        timestamp: messages[index].timestamp,
                      )
                    : OtherMessageWidget(
                        msg: messages[index].msg,
                        sender: messages[index].sender,
                        timestamp: messages[index].timestamp,
                      );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: "Send a message...",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 20,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_sharp,
                      size: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        iconSize: 20,
                        backgroundColor:
                            const Color.fromARGB(255, 233, 231, 130),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(10),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_messageController.text.trim().isNotEmpty) {
                          sendMessage(
                              _messageController.text, widget.user!.username!);
                          _messageController.clear();
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.location,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
