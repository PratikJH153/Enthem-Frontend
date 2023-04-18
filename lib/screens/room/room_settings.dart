// import "package:enthem2frontend/constants/page_padding.dart";
// import "package:enthem2frontend/helper/capitalize_text.dart";
// import "package:enthem2frontend/logic/repositories/user_api_repository.dart";
// import "package:enthem2frontend/models/room.dart";
// import "package:enthem2frontend/models/user.dart";
// import "package:flutter/cupertino.dart";
// import "package:flutter/material.dart";
// import "package:intl/intl.dart";

// class RoomSettings extends StatefulWidget {
//   final Room room;
//   final String distance;
//   final String userID;
//   const RoomSettings(
//       {required this.room,
//       required this.distance,
//       required this.userID,
//       super.key});

//   @override
//   State<RoomSettings> createState() => _RoomSettingsState();
// }

// class _RoomSettingsState extends State<RoomSettings> {
//   final UserAPIRepository _userAPIRepository = UserAPIRepository();
//   List<UserModel> _participants = [];
//   final DateFormat dateFormat = DateFormat("MMM d, h:mm a");

//   @override
//   void initState() {
//     print(widget.room.ownerID);
//     print(widget.userID);
//     getParticipants();
//     super.initState();
//   }

//   void getParticipants() async {
//     print(widget.room.participants);
//     final data = await _userAPIRepository.getUsers(widget.room.participants!
//         .map((e) => e["memberId"] != null ? e["memberId"] as String : "")
//         .toList());
//     setState(() {
//       _participants = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.more_vert),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: kPagePadding,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 25,
//                 vertical: 15,
//               ),
//               margin: const EdgeInsets.only(
//                 bottom: 10,
//                 top: 10,
//               ),
//               decoration: const BoxDecoration(
//                 color: Color.fromARGB(255, 37, 36, 37),
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               child: Text(
//                 widget.room.title.toString()[0].toUpperCase(),
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontFamily: "Poppins",
//                 ),
//               ),
//             ),
//             Text(
//               widget.room.title,
//               style: const TextStyle(
//                 fontSize: 30,
//                 fontFamily: "Poppins",
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Created at ${dateFormat.format(widget.room.createdAt)}",
//                 ),
//                 Text("${widget.distance} miles"),
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               "${widget.room.participants!.length} Participants",
//               style: const TextStyle(
//                 fontSize: 14.0,
//                 color: Colors.white54,
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _participants.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 10.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 15,
//                             vertical: 10,
//                           ),
//                           margin: const EdgeInsets.only(
//                             right: 10,
//                           ),
//                           decoration: const BoxDecoration(
//                             color: Color.fromARGB(255, 37, 36, 37),
//                             borderRadius: BorderRadius.all(Radius.circular(10)),
//                           ),
//                           child: Text(
//                             _participants[index]
//                                 .username!
//                                 .toString()[0]
//                                 .toUpperCase(),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontFamily: "Poppins",
//                             ),
//                           ),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               _participants[index].username!.capitalize(),
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "Exo2",
//                               ),
//                             ),
//                             _participants[index].id == widget.room.ownerID
//                                 ? Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 5,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: const BorderRadius.all(
//                                         Radius.circular(5),
//                                       ),
//                                       color: Colors.teal.withOpacity(0.1),
//                                     ),
//                                     child: const Text(
//                                       "Room Admin",
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.teal,
//                                       ),
//                                     ),
//                                   )
//                                 : const SizedBox(),
//                           ],
//                         ),
//                         const Spacer(),
//                         IconButton(
//                           onPressed: () {},
//                           icon: const Icon(Icons.more_vert),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             TextButton.icon(
//               onPressed: () {},
//               icon: const Icon(
//                 CupertinoIcons.escape,
//               ),
//               label: const Text("Exit Room"),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             widget.room.ownerID == widget.userID
//                 ? Padding(
//                     padding: const EdgeInsets.only(bottom: 20.0),
//                     child: TextButton.icon(
//                       onPressed: () {},
//                       icon: const Icon(
//                         CupertinoIcons.delete,
//                       ),
//                       label: const Text("Delete Room"),
//                     ),
//                   )
//                 : const SizedBox(
//                     height: 10,
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
