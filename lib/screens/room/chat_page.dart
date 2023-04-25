import 'package:enthem2frontend/constants/constants.dart';
import 'package:enthem2frontend/models/message.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/screens/room/room_settings.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/theme/theme.dart';
import 'package:enthem2frontend/utils/encryption.dart';
import 'package:enthem2frontend/widgets/dialog_box_widget.dart';
import 'package:enthem2frontend/widgets/other_message_widget.dart';
import 'package:enthem2frontend/widgets/own_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/custom_dialog_box.dart';
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
  bool isRemoved = false;
  bool isGroupDeleted = false;

  @override
  void initState() {
    connect();
    if (isRemoved) {
      Navigator.of(context).pop(
        showCustomDialog(
          context,
          DialogBoxWidget(
            title: "Admin removed you",
            des: "The admin has removed you from this group.",
            firstButton: "Ok",
            secondButton: "Cancel",
            firstOnTap: () {
              Navigator.of(context).pop();
            },
            secondOnTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } else if (isGroupDeleted) {
      Navigator.of(context).pop(
        showCustomDialog(
          context,
          DialogBoxWidget(
            title: "Room closed",
            des: "The admin has deleted the room.",
            firstButton: "Ok",
            secondButton: "Cancel",
            firstOnTap: () {
              Navigator.of(context).pop();
            },
            secondOnTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } else {
      socket!.on("sendMsgServer", (msg) {
        setState(() {
          messagesList.add(
            Message(
              type: "msg",
              msg: decrypt(msg["content"], dotenv.env["SECRET_KEY"]!),
              sender: decrypt(msg["sender"], dotenv.env["SECRET_KEY"]!),
              timestamp: DateTime.parse(msg["timestamp"]),
            ),
          );
        });
      });
      socket!.on("groupDeleted", (msg) {
        setState(() {
          isGroupDeleted = true;
        });
        Navigator.of(context).pop(
          showCustomDialog(
            context,
            DialogBoxWidget(
              title: "Room closed",
              des: "The admin has deleted the room.",
              firstButton: "Ok",
              secondButton: "Cancel",
              firstOnTap: () {
                Navigator.of(context).pop();
              },
              secondOnTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      });
      socket!.on("userRemoved", (msg) {
        if (msg["memberID"] == widget.user!.id) {
          setState(() {
            isRemoved = true;
          });
          Navigator.of(context).pop(
            showCustomDialog(
              context,
              DialogBoxWidget(
                title: "Admin removed you",
                des: "The admin has removed you from this group.",
                firstButton: "Ok",
                secondButton: "Cancel",
                firstOnTap: () {
                  Navigator.of(context).pop();
                },
                secondOnTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        }
      });
    }

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
      });
    } catch (err) {
      debugError(err.toString(), "chat_page.dart");
      rethrow;
    }
  }

  @override
  void dispose() {
    socket!.disconnect();
    socket!.close();
    socket!.destroy();
    socket!.dispose();
    _messageController.dispose();
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
        'content': encrypt(msg, dotenv.env["SECRET_KEY"]!),
        'sender': encrypt(sender, dotenv.env["SECRET_KEY"]!),
        'receiverChatID': encrypt(widget.room.id!, dotenv.env["SECRET_KEY"]!),
        "timestamp": DateTime.now().toString(),
      },
    );
  }

  void leaveRoom() async {
    bool canPop = await _onWillPop();
    if (canPop) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<bool> _onWillPop() async {
    bool shouldPop = await showCustomDialog(
      context,
      DialogBoxWidget(
        title: "Leave room",
        des: "Are you sure want to leave the room? We need you to stay!",
        firstButton: "Stay",
        secondButton: "Leave",
        firstOnTap: () => Navigator.of(context).pop(false),
        secondOnTap: () {
          Map<String, dynamic> data = {
            "roomID": widget.room.id,
            "memberID": widget.user!.id
          };
          socket!.emit("removeMember", data);
          Navigator.of(context).pop(true);
        },
      ),
    );
    return shouldPop;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoomSettings(
                          room: widget.room,
                          distance: widget.distance,
                          userID: widget.user!.id!,
                          socket: socket!,
                          onTap: () {
                            Map<String, dynamic> data = {
                              "roomID": widget.room.id,
                              "memberID": widget.user!.id
                            };
                            socket!.emit("removeMember", data);
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ),
                    );
                    // errorSnackBar(
                    //   context: context,
                    //   error: ErrorState.workingFeature,
                    // );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
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
              ElevatedButton.icon(
                onPressed: leaveRoom,
                icon: const Icon(Icons.waving_hand_rounded),
                label: const Text("Leave"),
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/chatscreen.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              backgroundColor.withOpacity(0.9),
              BlendMode.darken,
            ),
          ),
        ),
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Column(
            children: [
              messagesList.isEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              "assets/images/cat_chat.json",
                              height: 180,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                            const Text(
                              "Start your conversation, \nBy saying 👋 to the group",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
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
                  vertical: 12,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 37, 37, 37),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
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
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                                _messageController.text,
                                widget.user!.username!,
                              );
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
        ),
      ),
    );
  }
}
