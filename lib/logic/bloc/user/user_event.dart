part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserEvent extends UserEvent {}

class CreateUserEvent extends UserEvent {}

class UpdateUserEvent extends UserEvent {}

class DeleteUserEvent extends UserEvent {}

class UserErrorEvent extends UserEvent {
  final String error;

  const UserErrorEvent(this.error);

  @override
  List<Object> get props => [error];
}
