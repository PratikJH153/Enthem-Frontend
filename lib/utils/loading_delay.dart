import 'dart:async';

void loadingDelay(Function function) {
  Future.delayed(const Duration(seconds: 1), function as FutureOr Function()?);
}
