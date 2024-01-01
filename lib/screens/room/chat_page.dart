import 'package:enthem2/constants/constants.dart';
import 'package:enthem2/database/repositories/room_api_repository.dart';
import 'package:enthem2/helper/error_constants.dart';
import 'package:enthem2/models/message.dart';
import 'package:enthem2/models/room.dart';
import 'package:enthem2/models/user.dart';
import 'package:enthem2/screens/home/home_screen.dart';
import 'package:enthem2/services/debug_console.dart';
import 'package:enthem2/theme/theme.dart';
import 'package:enthem2/widgets/dialog_box_widget.dart';
import 'package:enthem2/widgets/other_message_widget.dart';
import 'package:enthem2/widgets/own_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final RoomAPIRepository _roomAPIRepository = RoomAPIRepository();

  final TextEditingController _messageController = TextEditingController();
  List<Message> messagesList = [];
  bool isRemoved = false;
  bool isGroupDeleted = false;

  @override
  void initState() {
    connect();
    if (isRemoved) {
      popUpForUserRemoved(context);
    } else if (isGroupDeleted) {
      popUpForGroupDeleted(context);
    } else {
      checkSockets();
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
          "memberID": widget.user!.uid,
          "username": widget.user!.username,
        });
      });
    } catch (err) {
      debugError(err.toString(), "chat_page.dart");
      rethrow;
    }
  }

  void checkSockets() {
    socket!.on("sendMsgServer", (msg) {
      setState(() {
        messagesList.add(
          Message(
            type: "msg",
            msg: msg["content"],
            sender: msg["sender"],
            timestamp: DateTime.parse(msg["timestamp"]),
          ),
        );
      });
    });
    socket!.on("groupDeleted", (data) {
      setState(() {
        isGroupDeleted = true;
      });
      popUpForGroupDeleted(context);
    });
    socket!.on("userRemoved", (data) {
      setState(() {
        widget.room.participants!.removeWhere((element) {
          return element["memberId"] == data["memberId"];
        });
        messagesList.add(
          Message(
            type: "left",
            msg: "left",
            sender: data["username"],
            timestamp: DateTime.now(),
          ),
        );
      });
      if (data["memberId"] == widget.user!.uid) {
        setState(() {
          isRemoved = true;
        });
        popUpForUserRemoved(context);
      }
    });
    socket!.on("bye", (data) {
      setState(() {
        widget.room.participants!.removeWhere((element) {
          return element["memberId"] == data["memberId"];
        });
        messagesList.add(
          Message(
            type: "left",
            msg: "left",
            sender: data["username"],
            timestamp: DateTime.now(),
          ),
        );
      });
    });
    socket!.on("userJoinedRoom", (data) {
      if (data["memberId"] != widget.user!.uid) {
        setState(() {
          widget.room.participants!.add(
            {
              "memberId": data["memberId"],
              "permit": false,
            },
          );
          messagesList.add(
            Message(
              type: "join",
              msg: "joined",
              sender: data["username"],
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    });
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
        'content': msg,
        'sender': sender,
        'receiverChatID': widget.room.id!,
        "timestamp": DateTime.now().toString(),
      },
    );
  }

  void leaveRoom() async {
    bool canPop = await _onWillPop();
    if (canPop) {
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.routeID,
          (route) => false,
        );
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
        firstOnTap: () => Navigator.of(context).pop(),
        secondOnTap: () {
          Map<String, dynamic> data = {
            "roomID": widget.room.id,
            "memberID": widget.user!.uid,
            "username": widget.user!.username,
          };
          socket!.emit("removeMember", data);
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeID,
            (route) => false,
          );
        },
      ),
    );
    return shouldPop;
  }

  void popUpForUserRemoved(BuildContext context) {
    showCustomDialog(
      context,
      DialogBoxWidget(
        title: "Admin removed you",
        des: "The admin has removed you from this group.",
        firstButton: "Ok",
        secondButton: "Cancel",
        firstOnTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeID,
            (route) => false,
          );
        },
        secondOnTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeID,
            (route) => false,
          );
        },
      ),
    ).then(
      (value) => Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.routeID,
        (route) => false,
      ),
    );
  }

  void popUpForGroupDeleted(BuildContext context) {
    showCustomDialog(
      context,
      DialogBoxWidget(
        title: "Room closed",
        des: "The admin has deleted the room.",
        firstButton: "Ok",
        secondButton: "Cancel",
        firstOnTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeID,
            (route) => false,
          );
        },
        secondOnTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeID,
            (route) => false,
          );
        },
      ),
    ).then(
      (value) => Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.routeID,
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isRemoved || isGroupDeleted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeID,
            (route) => false,
          );
        } else {
          leaveRoom();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Tooltip(
                    waitDuration: const Duration(milliseconds: 0),
                    message: widget.room.title,
                    // onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => RoomSettings(
                    //       room: widget.room,
                    //       distance: widget.distance,
                    //       userID: widget.user!.uid!,
                    //       socket: socket!,
                    //       onTap: () {
                    //         Map<String, dynamic> data = {
                    //           "roomID": widget.room.id,
                    //           "memberID": widget.user!.uid,
                    //           "username": widget.user!.username,
                    //         };
                    //         socket!.emit("adminRemoved", data);
                    //         Navigator.of(context).pushNamedAndRemoveUntil(
                    //           HomePage.routeID,
                    //           (route) => false,
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // );
                    // errorSnackBar(
                    //   context: context,
                    //   error: ErrorState.workingFeature,
                    // );
                    // },
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
                          "Please have a friendly chat",
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
                ),
                widget.user!.uid == widget.room.ownerID
                    ? PopupMenuButton<int>(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              showCustomDialog(
                                context,
                                DialogBoxWidget(
                                  title: "Delete room",
                                  des: "Are you sure want to delete the room?",
                                  firstButton: "Yes",
                                  secondButton: "No",
                                  firstOnTap: () async {
                                    final isDeleted =
                                        await _roomAPIRepository.deleteRoom(
                                      roomID: widget.room.id!,
                                      ownerID: widget.user!.uid!,
                                    );
                                    socket!.emit("deleteRoom",
                                        {"roomID": widget.room.id!});
                                    if (isDeleted) {
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          HomePage.routeID,
                                          (route) => false,
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        errorSnackBar(
                                          context: context,
                                          error: ErrorState.deleteRoomError,
                                        );
                                      }
                                    }
                                  },
                                  secondOnTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                              );
                            },
                            value: 1,
                            // row has two child icon and text.
                            child: const Text("Delete room"),
                          ),
                        ],
                        offset: const Offset(0, 50),
                        color: backgroundColor,
                        elevation: 2,
                      )
                    : const SizedBox()
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
                            return (messages[index].type == "left" ||
                                    messages[index].type == "join")
                                ? Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                        vertical: 3,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Text(
                                        "${messages[index].sender} ${messages[index].msg}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : messages[index].type == "ownMsg"
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
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: const Icon(
                        //     Icons.emoji_emotions_sharp,
                        //     size: 30,
                        //   ),
                        // ),
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
      ),
    );
  }
}
