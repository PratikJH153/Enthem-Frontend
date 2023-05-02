import 'dart:async';

void loadingDelay(Function function) {
  Future.delayed(
      const Duration(milliseconds: 500), function as FutureOr Function()?);
}
