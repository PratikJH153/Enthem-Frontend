import 'package:flutter/cupertino.dart';
import '/widgets/loading_widget.dart';
import '/database/repositories/room_api_repository.dart';
import '/models/user.dart';
import '/models/room.dart';
import '/services/debug_console.dart';
import 'user_api_provider.dart';

class UserDataProvider extends ChangeNotifier {
  static const String filename = "user_provider.dart";
  final _userProvider = UserAPIProvider();
  final RoomAPIRepository _roomAPIRepository = RoomAPIRepository();

  AsyncState userDataAsyncState = AsyncState.isLoading;

  List<Room> rooms = [];
  UserModel? userData;

  Future<UserModel?> setUserData() async {
    try {
      setUserDataLoading();

      final String userId = _userProvider.getUserID();
      final data = await _userProvider.getUser(userId);
      List<Room> userRooms =
          await _roomAPIRepository.getRoomsByOwnerID(ownerID: data.id!);

      rooms = userRooms;
      userData = data;

      setUserDataLoading(isLoading: false);
      return data;
    } catch (error) {
      debugError(error.toString(), filename);
      userDataAsyncState = AsyncState.wentWrong;
      notifyListeners();
    }
    return null;
  }

  void setUserDataLoading({bool isLoading = true}) {
    userDataAsyncState =
        isLoading ? AsyncState.isLoading : AsyncState.hasLoaded;
    notifyListeners();
  }
}
