import 'package:enthem2frontend/helper/display_user_dp.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:flutter/material.dart';

class ChatParticipantTileWidget extends StatelessWidget {
  final UserModel participant;
  final String ownerID;
  final String currentUserID;
  final VoidCallback onTap;
  const ChatParticipantTileWidget({
    required this.participant,
    required this.ownerID,
    required this.currentUserID,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onLongPress: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              margin: const EdgeInsets.only(
                right: 10,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 37, 36, 37),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                displayUserPicture(participant.username!),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.id == currentUserID
                      ? "You"
                      : participant.username!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Exo2",
                  ),
                ),
                participant.id == ownerID
                    ? Container(
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
                          "Room Admin",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.teal,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
