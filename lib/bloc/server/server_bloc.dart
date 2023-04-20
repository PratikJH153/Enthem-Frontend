import 'package:flutter_bloc/flutter_bloc.dart';
import 'server_state.dart';

class ServerBloc extends Cubit<ServerState> {
  ServerBloc() : super(ServerFetching());
}
