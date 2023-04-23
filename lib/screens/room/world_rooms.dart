import 'package:enthem2frontend/database/repositories/room_api_repository.dart';
import 'package:enthem2frontend/helper/compute_distance.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/views/no_rooms_found_view.dart';
import 'package:enthem2frontend/widgets/custom_snackbar.dart';
import 'package:enthem2frontend/widgets/loading_widget.dart';
import 'package:enthem2frontend/widgets/room_tile.dart';
import 'package:enthem2frontend/widgets/shaded_list_widget.dart';
import 'package:flutter/material.dart';

class WorldRoomsPage extends StatefulWidget {
  final UserModel user;
  const WorldRoomsPage({required this.user, super.key});

  @override
  State<WorldRoomsPage> createState() => _WorldRoomsPageState();
}

class _WorldRoomsPageState extends State<WorldRoomsPage> {
  static const String filename = "world_rooms.dart";
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
      final data = await _apiRepository.getPopularRooms(
        page: 1,
      );
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
                          [widget.user.longitude!, widget.user.latitude!],
                          roomsList[index].coordinates,
                        ).toStringAsFixed(2);
                        return RoomTileWidget(
                          user: widget.user,
                          room: roomsList[index],
                          distance: distance,
                        );
                      },
                    ),
            ),
    );
  }
}
