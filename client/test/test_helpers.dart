import 'dart:async';

void executeForDuration(Duration duration, Function action) {
  final timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
    action();
  });

  Future.delayed(duration, () {
    timer.cancel();
  });
}
