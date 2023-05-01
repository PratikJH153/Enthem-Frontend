import 'package:enthem2frontend/database/repositories/room_api_repository.dart';
import 'package:enthem2frontend/helper/compute_distance.dart';
import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/theme/theme.dart';
import 'package:enthem2frontend/widgets/loading_widget.dart';
import 'package:enthem2frontend/widgets/primary_button.dart';
import 'package:enthem2frontend/widgets/room_tile.dart';
import 'package:enthem2frontend/widgets/shaded_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchRoomsView extends StatefulWidget {
  final UserModel user;
  const SearchRoomsView({
    required this.user,
    super.key,
  });

  @override
  State<SearchRoomsView> createState() => _SearchRoomsViewState();
}

class _SearchRoomsViewState extends State<SearchRoomsView> {
  List<Room> searhList = [];
  final TextEditingController _searchController = TextEditingController();
  final RoomAPIRepository _roomAPIRepository = RoomAPIRepository();
  final String filename = "search_rooms_view.dart";
  bool _isLoading = false;
  bool searched = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void searchRoom(String searchString) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        setState(() {
          _isLoading = true;
          searched = true;
        });
        final data =
            await _roomAPIRepository.searchRooms(searchString: searchString);
        setState(() {
          searhList = data;
        });
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        debugError(err.toString(), filename);
        errorSnackBar(
          context: context,
          error: ErrorState.serverError,
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    searched = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 50,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.black38,
                    ),
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        hintText: "Search a room...",
                        border: InputBorder.none,
                      ),
                      validator: (val) {
                        if (_searchController.text.trim().isEmpty ||
                            _searchController.text.length < 3) {
                          return "Title should be atleast 3 characters";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                PrimaryButton(
                  icon: CupertinoIcons.search,
                  onTap: () {
                    searchRoom(_searchController.text.trim());
                  },
                ),
              ],
            ),
          ),
          searhList.isEmpty && !searched
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        "assets/images/search.json",
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Search for rooms you prefer!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Type the title or the description of the room you want to search",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ShadedList(
                    widget: _isLoading
                        ? const Center(child: LoadingWidget())
                        : searhList.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    "assets/images/404.json",
                                    height: 250,
                                    width: 250,
                                  ),
                                  const Text(
                                    "Rooms not found!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                                      "Try to be specific when typing the title of the room.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 100,
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(
                                  bottom: 100,
                                  top: 20,
                                ),
                                itemCount: searhList.length,
                                itemBuilder: (context, index) {
                                  final room = searhList[index];
                                  final distance = computeDistance(
                                    [
                                      widget.user.longitude!,
                                      widget.user.latitude!
                                    ],
                                    searhList[index].coordinates,
                                  ).toStringAsFixed(2);
                                  return RoomTileWidget(
                                    user: widget.user,
                                    room: room,
                                    distance: distance,
                                  );
                                },
                              ),
                  ),
                ),
        ],
      ),
    );
  }
}
