import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/screens/room/chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class RoomTileWidget extends StatelessWidget {
  final UserModel user;
  final Room room;
  final String distance;
  const RoomTileWidget({
    required this.user,
    required this.room,
    required this.distance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 10,
      ),
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 37, 36, 37),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: InkWell(
        onTap: () {
          if (!room.participants!.contains((e) => e["memberId"])) {
            room.participants!.add({
              "memberId": user.id,
              "permit": false,
            });
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(
                user: user,
                room: room,
                distance: distance,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 17,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeago.format(room.createdAt).toString(),
                  style: const TextStyle(
                    color: Colors.white60,
                  ),
                ),
                Text(
                  "$distance miles",
                  style: const TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.more_horiz),
                // ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.person_2),
                  label: Text(room.participants!.length.toString()),
                ),
                IconButton(
                  onPressed: () {
                    errorSnackBar(
                      context: context,
                      error: ErrorState.workingFeature,
                    );
                  },
                  icon: const Icon(CupertinoIcons.paperplane),
                ),
                // TextButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(CupertinoIcons.flame),
                //   label: const Text("500"),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
