import '../../widgets/loading_widget.dart';
import '/models/room.dart';
import '/models/user.dart';
import '/database/repositories/room_api_repository.dart';
import 'package:flutter/cupertino.dart';
import '/services/debug_console.dart';

class RoomsProvider extends ChangeNotifier {
  static const String filename = "friend_provider.dart";
  final RoomAPIRepository repository = RoomAPIRepository();

  AsyncState nearbyAsyncState = AsyncState.isLoading;
  AsyncState forYouAsyncState = AsyncState.isLoading;

  List<Room> nearbyList = [];
  List<Room> worldList = [];

  Future<void> setNearbyData(UserModel user) async {
    try {
      setNearbyLoading();

      final introduceRoom = await repository.getIntroduceRoom();
      introduceRoom.isIntroduce = true;

      final roomsList = await repository.getAllRooms(
        miles: 10,
        coordinates: [
          user.longitude ?? 0,
          user.latitude ?? -90,
        ],
        page: 1,
      );

      roomsList.insert(0, introduceRoom);
      nearbyList = roomsList;

      setNearbyLoading(isLoading: false);
    } catch (error) {
      debugError(error.toString(), filename);
      nearbyAsyncState = AsyncState.wentWrong;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> setWorldListData() async {
    try {
      setWorldLoading();

      final introduceRoom = await repository.getIntroduceRoom();
      introduceRoom.isIntroduce = true;

      final roomsList = await repository.getPopularRooms(
        page: 1,
      );

      roomsList.insert(0, introduceRoom);
      worldList = roomsList;

      setWorldLoading(isLoading: false);
    } catch (error) {
      debugError(error.toString(), filename);
      forYouAsyncState = AsyncState.wentWrong;
      notifyListeners();
      rethrow;
    }
  }

  void setNearbyLoading({bool isLoading = true}) {
    nearbyAsyncState = isLoading ? AsyncState.isLoading : AsyncState.hasLoaded;
    notifyListeners();
  }

  void setWorldLoading({bool isLoading = true}) {
    forYouAsyncState = isLoading ? AsyncState.isLoading : AsyncState.hasLoaded;
    notifyListeners();
  }
}
