import '/models/friend.dart';
import 'package:equatable/equatable.dart';

abstract class NearYouState extends Equatable {}

class NearYouLoadingState extends NearYouState {
  @override
  List<Object?> get props => [];
}

class NearYouFetchedState extends NearYouState {
  final List<Friend> friendsList;

  NearYouFetchedState(this.friendsList);

  @override
  List<Object?> get props => [friendsList];
}

class NearYouFailedState extends NearYouState {
  final dynamic error;

  NearYouFailedState(this.error);

  @override
  List<Object?> get props => [error];
}
