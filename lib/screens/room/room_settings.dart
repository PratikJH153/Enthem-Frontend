import "package:enthem2frontend/constants/page_padding.dart";
import "package:enthem2frontend/database/repositories/room_api_repository.dart";
import "package:enthem2frontend/helper/error_constants.dart";
import "package:enthem2frontend/logic/repositories/user_api_repository.dart";
import "package:enthem2frontend/models/room.dart";
import "package:enthem2frontend/models/user.dart";
import "package:enthem2frontend/screens/home/home_screen.dart";
import "package:enthem2frontend/widgets/chat_participant_tile.dart";
import "package:enthem2frontend/widgets/custom_dialog_box.dart";
import "package:enthem2frontend/widgets/dialog_box_widget.dart";
import "package:enthem2frontend/widgets/loading_widget.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:lottie/lottie.dart";
import 'package:socket_io_client/socket_io_client.dart' as io;

class RoomSettings extends StatefulWidget {
  final Room room;
  final String distance;
  final String userID;
  final VoidCallback onTap;
  final io.Socket socket;
  const RoomSettings({
    required this.room,
    required this.distance,
    required this.userID,
    required this.onTap,
    required this.socket,
    super.key,
  });

  @override
  State<RoomSettings> createState() => _RoomSettingsState();
}

class _RoomSettingsState extends State<RoomSettings> {
  final UserAPIRepository _userAPIRepository = UserAPIRepository();
  final RoomAPIRepository _roomAPIRepository = RoomAPIRepository();
  List<UserModel> _participants = [];
  late UserModel roomOwner;
  final DateFormat dateFormat = DateFormat("MMM d, h:mm a");
  bool _isloading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      _isloading = true;
    });
    await getParticipants();
    await getRoomOwner();
    setState(() {
      _isloading = false;
    });
  }

  Future<void> getParticipants() async {
    final data = await _userAPIRepository.getUsers(widget.room.participants!
        .toSet()
        .toList()
        .map((e) => e["memberId"] != null ? e["memberId"] as String : "")
        .toList());
    setState(() {
      _participants = data;
    });
  }

  Future<void> getRoomOwner() async {
    final data = await _userAPIRepository.getUser(widget.room.ownerID);
    setState(() {
      roomOwner = data;
    });
  }

  Future<bool> _onWillPop() async {
    bool shouldPop = await showCustomDialog(
      context,
      DialogBoxWidget(
        title: "Leave room",
        des: "Are you sure want to leave this room? We need you to stay!",
        firstButton: "Stay",
        secondButton: "Leave",
        firstOnTap: () => Navigator.of(context).pop(false),
        secondOnTap: widget.onTap,
      ),
    );
    return shouldPop;
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

  void removeMember(String participantID) async {
    showCustomDialog(
      context,
      DialogBoxWidget(
        title: "Remove member",
        des: "Are you sure want to remove the member?",
        firstButton: "Yes",
        secondButton: "No",
        firstOnTap: () {
          Map<String, dynamic> data = {
            "roomID": widget.room.id,
            "memberID": participantID,
          };
          widget.socket.emit("adminRemoved", data);
          setState(() {
            _participants.removeWhere((user) {
              return user.id == data["memberId"];
            });
          });

          Navigator.of(context).pop(true);
        },
        secondOnTap: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isloading
          ? const LoadingWidget()
          : Padding(
              padding: kPagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Created at ${dateFormat.format(widget.room.createdAt)}",
                      ),
                      Text("${widget.distance} miles"),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: InkWell(
                          onLongPress: () {},
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 37, 36, 37),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Lottie.asset(
                                  "assets/images/crown.json",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    roomOwner.username!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Exo2",
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: Colors.teal.withOpacity(0.1),
                                    ),
                                    child: const Text(
                                      "Owner",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "${_participants.length} Participants",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _participants.length,
                      itemBuilder: (context, index) {
                        final participant = _participants[index];
                        return ChatParticipantTileWidget(
                          participant: participant,
                          ownerID: widget.room.ownerID,
                          currentUserID: widget.userID,
                          onTap: () {
                            if (widget.userID == widget.room.ownerID &&
                                participant.id != widget.userID) {
                              removeMember(participant.id!);
                            } else {
                              return;
                            }
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: leaveRoom,
                    icon: const Icon(
                      Icons.waving_hand_rounded,
                    ),
                    label: const Text("Leave Room"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.room.ownerID == widget.userID &&
                          !widget.room.isIntroduce!
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
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
                                      ownerID: widget.userID,
                                    );
                                    widget.socket.emit("deleteRoom",
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
                            icon: const Icon(
                              CupertinoIcons.tray_arrow_up,
                            ),
                            label: const Text("Delete Room"),
                          ),
                        )
                      : const SizedBox(
                          height: 10,
                        ),
                ],
              ),
            ),
    );
  }
}
