abstract class InternetState {}

class InternetAvailableState extends InternetState {}

class InternetFetchingState extends InternetState {}

class InternetNotFoundState extends InternetState {}


abstract class InternetEvent {}

class InternetAvailableEvent extends InternetEvent {}

class InternetFetchingEvent extends InternetEvent {}

class InternetNotFoundEvent extends InternetEvent {}
