import 'package:enthem2frontend/logic/bloc/friend/for_you_state.dart';
import 'package:enthem2frontend/models/friend.dart';
import 'package:enthem2frontend/utils/loading_delay.dart';

import '/logic/repositories/user_api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/logic/provider/friend_api_provider.dart';

class ForYouBloc extends Cubit<ForYouState> {
  static final _provider = FriendAPIProvider();
  final UserAPIRepository _repository = UserAPIRepository();

  ForYouBloc() : super(ForYouLoadingState()) {
    final String userId = _repository.getUserID();
    fetchFriends(userId, 0);
  }

  Future<void> fetchFriends(String userId, int offset) async {
    loadingDelay(() async {
      try {
        List<Friend> friendList = await _provider.foryou(userId, offset);

        emit(ForYouFetchedState(friendList));
      } catch (e) {
        emit(ForYouFailedState(e));
      }
    });
  }
}
