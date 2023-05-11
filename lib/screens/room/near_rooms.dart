import '/logic/provider/rooms_provider.dart';
import '/logic/provider/user_provider.dart';
import '/models/user.dart';
import '/helper/compute_distance.dart';
import '/views/no_rooms_found_view.dart';
import '/widgets/loading_widget.dart';
import '/widgets/room_tile.dart';
import '/widgets/shaded_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NearRoomsPage extends StatefulWidget {
  const NearRoomsPage({super.key});

  @override
  State<NearRoomsPage> createState() => _NearRoomsPageState();
}

class _NearRoomsPageState extends State<NearRoomsPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshRooms() async {
    final RoomsProvider roomsProvider = context.read<RoomsProvider>();
    final UserDataProvider userDataProvider = context.read<UserDataProvider>();

    UserModel user = userDataProvider.userData!;
    roomsProvider.setNearbyData(user);
  }

  @override
  Widget build(BuildContext context) {
    final RoomsProvider roomsProvider = context.watch<RoomsProvider>();
    final UserDataProvider userDataProvider = context.watch<UserDataProvider>();

    UserModel user = userDataProvider.userData!;
    final roomsList = roomsProvider.nearbyList;

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
                  final room = roomsList[index];
                  final distance = computeDistance(
                    [user.longitude!, user.latitude!],
                    roomsList[index].coordinates,
                  ).toStringAsFixed(2);
                  return RoomTileWidget(
                    user: user,
                    room: room,
                    distance: distance,
                  );
                },
              ),
      ),
    );
  }
}
