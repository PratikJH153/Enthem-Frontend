// import 'package:enthem2/database/repositories/room_api_repository.dart';
// import 'package:enthem2/logic/repositories/user_api_repository.dart';
// import 'package:enthem2/models/room.dart';
// import "package:flutter/material.dart";

// import 'package:enthem2/constants/page_padding.dart';
// import 'package:enthem2/widgets/auth_continue_button.dart';
// import 'package:enthem2/widgets/custom_snackbar.dart';

// class AddRoomPage extends StatefulWidget {
//   static const routeID = "/addroompage";

//   const AddRoomPage({super.key});

//   @override
//   State<AddRoomPage> createState() => _AddRoomPageState();
// }

// class _AddRoomPageState extends State<AddRoomPage> {
//   final UserAPIRepository _userAPIRepository = UserAPIRepository();
//   final RoomAPIRepository _apiRepository = RoomAPIRepository();
//   final TextEditingController _roomController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   static const String filename = "userdata_screen.dart";

//   @override
//   void dispose() {
//     _roomController.dispose();
//     super.dispose();
//   }

//   void addRoom() async {
//     final form = _formKey.currentState!;
//     if (form.validate()) {
//       try {
//         final Room room = Room(
//           title: _roomController.text.trim(),
//           ownerID: _userAPIRepository.getUserID(),
//           createdAt: DateTime.now(),
//         );
//         await _apiRepository.addRoom(room);
//         if (context.mounted) {
//           Navigator.of(context).pop();
//         }
//       } catch (err) {
//         showSnackBar(
//           context: context,
//           status: "failure",
//           title: "Server issue!",
//           des: "Couldn't connect to the server",
//         );
//       }
//     } else {
//       if (context.mounted) {
//         showSnackBar(
//           context: context,
//           status: "warning",
//           title: "Title is required!",
//           des: "Please try again",
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: AuthContinueButton(
//         des: "This appears on your chat profile. You can change it later.",
//         isDisabled: _roomController.text.trim().isEmpty,
//         onTap: addRoom,
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: kPagePadding.copyWith(
//               top: 20,
//               left: 35,
//               right: 35,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "What's in your mind?",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(right: 15.0),
//                   child: Text(
//                     "Add a groovy title for your temporary room",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _roomController,
//                         cursorColor: Colors.white,
//                         style: const TextStyle(
//                           fontSize: 35,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         textCapitalization: TextCapitalization.words,
//                         keyboardType: TextInputType.name,
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           hintStyle: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white38,
//                           ),
//                           hintText: "Add a title",
//                         ),
//                         onChanged: (val) {
//                           setState(() {});
//                         },
//                         validator: (val) {
//                           if (val!.trim().isNotEmpty && 5 < val.trim().length) {
//                             return null;
//                           }
//                           return "Title should be atleast of 5 characters";
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
