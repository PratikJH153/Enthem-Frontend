import 'package:enthem2frontend/database/repositories/room_api_repository.dart';
import 'package:enthem2frontend/helper/compute_distance.dart';
import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/screens/room/chat_page.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/views/no_rooms_found_view.dart';
import 'package:enthem2frontend/widgets/custom_snackbar.dart';
import 'package:enthem2frontend/widgets/loading_widget.dart';
import 'package:enthem2frontend/widgets/shaded_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;

class NearRoomsPage extends StatefulWidget {
  final UserModel? user;
  const NearRoomsPage({this.user, super.key});

  @override
  State<NearRoomsPage> createState() => _NearRoomsPageState();
}

class _NearRoomsPageState extends State<NearRoomsPage> {
  static const String filename = "near_rooms.dart";
  final RoomAPIRepository _apiRepository = RoomAPIRepository();
  late List<Room> roomsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    getRoomsList();
    super.initState();
  }

  Future<void> getRoomsList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final data = await _apiRepository.getAllRooms(miles: 10, coordinates: [
        widget.user!.longitude ?? 0,
        widget.user!.latitude ?? -90,
      ]);
      setState(() {
        roomsList = data;
        _isLoading = false;
      });
    } catch (err) {
      debugError(err.toString(), filename);
      showSnackBar(
        context: context,
        status: "failure",
        title: "Server issue!",
        des: "Couldn't connect to the server",
      );
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  Future refresh() async {
    await getRoomsList();
  }

  @override
  Widget build(BuildContext context) {
    return ShadedList(
      widget: _isLoading
          ? const Center(child: LoadingWidget())
          : RefreshIndicator(
              onRefresh: refresh,
              child: roomsList.isEmpty
                  ? NoRoomsFoundScreen(onTap: refresh)
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 100,
                        top: 20,
                      ),
                      itemCount: roomsList.length,
                      itemBuilder: (context, index) {
                        final distance = computeDistance(
                          [widget.user!.longitude!, widget.user!.latitude!],
                          roomsList[index].coordinates,
                        ).toStringAsFixed(2);
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    user: widget.user!,
                                    room: roomsList[index],
                                    distance: distance,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  roomsList[index].title,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      timeago
                                          .format(roomsList[index].createdAt)
                                          .toString(),
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
                                      label: Text(roomsList[index]
                                          .participants!
                                          .length
                                          .toString()),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        errorSnackBar(
                                          context: context,
                                          error: ErrorState.workingFeature,
                                        );
                                      },
                                      icon:
                                          const Icon(CupertinoIcons.paperplane),
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
                      },
                    ),
            ),
    );
  }
}
