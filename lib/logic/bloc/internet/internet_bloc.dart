import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  InternetBloc() : super(InternetFetchingState()) {
    on<InternetNotFoundEvent>((event, emit) => emit(InternetNotFoundState()));
    on<InternetAvailableEvent>((event, emit) => emit(InternetAvailableState()));

    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        add(InternetAvailableEvent());
      } else {
        add(InternetNotFoundEvent());
      }
    });
  }

  @override
  Future<void> close() {
    // connectivitySubscription?.cancel();
    return super.close();
  }
}
