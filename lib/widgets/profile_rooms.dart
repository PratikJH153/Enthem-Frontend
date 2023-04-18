import 'package:enthem2frontend/models/room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileRoomsWidget extends StatelessWidget {
  final Room room;
  const ProfileRoomsWidget({required this.room, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 20,
      ),
      height: 200,
      width: 200,
      margin: const EdgeInsets.only(right: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 37, 36, 37),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            room.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.flame_fill,
                    ),
                    label: Text(room.votes.toString()),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.person_2_fill),
                    label: Text(room.participants!.length.toString()),
                  ),
                ],
              )),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
