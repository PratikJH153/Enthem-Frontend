import 'package:enthem2frontend/models/friend.dart';
import 'package:equatable/equatable.dart';

abstract class ForYouState extends Equatable {}

class ForYouLoadingState extends ForYouState {
  @override
  List<Object?> get props => [];
}

class ForYouFetchedState extends ForYouState {
  final List<Friend> friendsList;

  ForYouFetchedState(this.friendsList);

  @override
  List<Object?> get props => [friendsList];
}

class ForYouFailedState extends ForYouState {
  final dynamic error;

  ForYouFailedState(this.error);

  @override
  List<Object?> get props => [error];
}
