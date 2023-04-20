import '/logic/repositories/user_api_repository.dart';
import '/models/friend.dart';
import '/logic/provider/friend_api_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'near_you_state.dart';

class NearYouBloc extends Cubit<NearYouState> {
  static final _provider = FriendAPIProvider();
  final UserAPIRepository _repository = UserAPIRepository();

  NearYouBloc() : super(NearYouLoadingState()) {
    final String userId = _repository.getUserID();
    fetchNearby(userId, 0);
  }

  Future<void> fetchNearby(String userId, int offset) async {
    try {
      List<Friend> friendList = await _provider.nearby(userId, offset);

      emit(NearYouFetchedState(friendList));
    } catch (e) {
      emit(NearYouFailedState(e));
    }
  }
}
