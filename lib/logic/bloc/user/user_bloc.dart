// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:enthem2frontend/logic/repositories/user_api_repository.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  static late UserModel user;
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) {
      final UserAPIRepository apiRepository = UserAPIRepository();

      on<GetUserEvent>((event, emit) async {
        try {
          emit(UserLoading());
          final userSQL =
              await apiRepository.getUserSQL(apiRepository.getUserID());
          user = userSQL;
          emit(UserLoaded(user));
        } on NetworkError {
          emit(const UserErrorState(
              "Failed to fetch data. is your device online?"));
        } catch (err) {
          emit(const UserErrorState(
              "Failed to fetch data. is your device online?"));
        }
      });
    });
  }
}
