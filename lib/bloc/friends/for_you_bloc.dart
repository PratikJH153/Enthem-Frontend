import '/bloc/friends/for_you_state.dart';
import '/logic/repositories/user_api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/friend.dart';
import '/logic/provider/friend_api_provider.dart';

class ForYouBloc extends Cubit<ForYouState> {
  static final _provider = FriendAPIProvider();
  final UserAPIRepository _repository = UserAPIRepository();

  ForYouBloc() : super(ForYouLoadingState()) {
    final String userId = _repository.getUserID();
    fetchFriends(userId, 0);
  }

  Future<void> fetchFriends(String userId, int offset) async {
    try {
      List<Friend> friendList = await _provider.foryou(userId, offset);

      emit(ForYouFetchedState(friendList));
    } catch (e) {
      emit(ForYouFailedState(e));
    }
  }
}
