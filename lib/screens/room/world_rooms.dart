import '../../logic/provider/user_provider.dart';
import '/helper/compute_distance.dart';
import '/models/user.dart';
import '/views/no_rooms_found_view.dart';
import '/widgets/loading_widget.dart';
import '/widgets/room_tile.dart';
import '/widgets/shaded_list_widget.dart';
import '/logic/provider/rooms_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorldRoomsPage extends StatefulWidget {
  const WorldRoomsPage({super.key});

  @override
  State<WorldRoomsPage> createState() => _WorldRoomsPageState();
}

class _WorldRoomsPageState extends State<WorldRoomsPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshRooms() async {
    final RoomsProvider roomsProvider = context.read<RoomsProvider>();
    roomsProvider.setWorldListData();
  }

  @override
  Widget build(BuildContext context) {
    final RoomsProvider roomsProvider = context.watch<RoomsProvider>();
    final UserDataProvider userDataProvider = context.watch<UserDataProvider>();

    UserModel user = userDataProvider.userData!;
    final roomsList = roomsProvider.worldList;

    if (roomsProvider.nearbyAsyncState == AsyncState.isLoading) {
      return const LoadingWidget();
    }

    if (roomsProvider.nearbyAsyncState == AsyncState.wentWrong) {
      return const WentWrongPage();
    }

    return ShadedList(
      widget: RefreshIndicator(
        onRefresh: _refreshRooms,
        child: roomsList.isEmpty
            ? NoRoomsFoundScreen(onTap: _refreshRooms)
            : ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 100,
                  top: 20,
                ),
                itemCount: roomsList.length,
                itemBuilder: (context, index) {
                  final distance = computeDistance(
                    [user.longitude!, user.latitude!],
                    roomsList[index].coordinates,
                  ).toStringAsFixed(2);
                  return RoomTileWidget(
                    user: user,
                    room: roomsList[index],
                    distance: distance,
                  );
                },
              ),
      ),
    );
  }
}
