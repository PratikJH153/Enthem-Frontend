import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '/logic/provider/friend_provider.dart';
import '/logic/provider/rooms_provider.dart';
import '/logic/provider/user_provider.dart';
import '/models/user.dart';
import '/services/debug_console.dart';

class GlobalDataProvider {
  static const String filename = "friend_provider.dart";

  static Future<UserModel> initializeProviders(BuildContext context) async {
    final FriendProvider friendProvider = context.read<FriendProvider>();
    final UserDataProvider userDataProvider = context.read<UserDataProvider>();
    final RoomsProvider roomsProvider = context.read<RoomsProvider>();

    try {
      UserModel? user = await userDataProvider.setUserData();
      if (user == null) {
        throw Error();
      }

      await friendProvider.nearby(user.uid!, 0);
      await friendProvider.foryou(user.uid!, 0);
      await roomsProvider.setNearbyData(user);
      await roomsProvider.setWorldListData();

      return user;
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  static Future<void> resetFriendsProvider(BuildContext context) async {
    final UserDataProvider userDataProvider = context.read<UserDataProvider>();
    final FriendProvider friendProvider = context.read<FriendProvider>();

    await friendProvider.nearby(userDataProvider.userData!.uid!, 0);
    await friendProvider.foryou(userDataProvider.userData!.uid!, 0);
  }

  static Future<void> resetUserDataProvider(BuildContext context) async {
    await initializeProviders(context);
  }

  static Future<void> resetRoomsDataProvider(BuildContext context) async {
    final RoomsProvider roomsProvider = context.read<RoomsProvider>();
    final UserDataProvider userDataProvider = context.read<UserDataProvider>();

    await roomsProvider.setNearbyData(userDataProvider.userData!);
    await roomsProvider.setWorldListData();
  }
}
