import 'dart:async';

void loadingDelay(Function function) {
  Future.delayed(
      const Duration(milliseconds: 200), function as FutureOr Function()?);
}
