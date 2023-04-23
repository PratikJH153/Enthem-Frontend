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
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class RoomSettings extends StatefulWidget {
  final Room room;
  final String distance;
  final String userID;
  final VoidCallback onTap;
  const RoomSettings({
    required this.room,
    required this.distance,
    required this.userID,
    required this.onTap,
    super.key,
  });

  @override
  State<RoomSettings> createState() => _RoomSettingsState();
}

class _RoomSettingsState extends State<RoomSettings> {
  final UserAPIRepository _userAPIRepository = UserAPIRepository();
  final RoomAPIRepository _roomAPIRepository = RoomAPIRepository();
  List<UserModel> _participants = [];
  final DateFormat dateFormat = DateFormat("MMM d, h:mm a");

  @override
  void initState() {
    getParticipants();
    super.initState();
  }

  void getParticipants() async {
    print(widget.room.participants);
    final data = await _userAPIRepository.getUsers(widget.room.participants!
        .map((e) => e["memberId"] != null ? e["memberId"] as String : "")
        .toList());
    setState(() {
      _participants = data;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Padding(
        padding: kPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 25,
            //     vertical: 15,
            //   ),
            //   margin: const EdgeInsets.only(
            //     bottom: 10,
            //     top: 10,
            //   ),
            //   decoration: const BoxDecoration(
            //     color: Color.fromARGB(255, 37, 36, 37),
            //     borderRadius: BorderRadius.all(Radius.circular(20)),
            //   ),
            //   child: Text(
            //     widget.room.title.toString()[0].toUpperCase(),
            //     style: const TextStyle(
            //       fontSize: 24,
            //       fontFamily: "Poppins",
            //     ),
            //   ),
            // ),
            Text(
              widget.room.title,
              style: const TextStyle(
                fontSize: 28,
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
              height: 10,
            ),
            Text(
              "${widget.room.participants!.length} Participants",
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white54,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _participants.length,
                itemBuilder: (context, index) {
                  return ChatParticipantTileWidget(
                    participant: _participants[index],
                    ownerID: widget.room.ownerID,
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
            widget.room.ownerID == widget.userID
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
                              if (isDeleted) {
                                if (context.mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
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
                              Navigator.of(context).pop();
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
