import 'dart:async';

Future<void> executeForDuration(Duration duration, Function action) async {
  final timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
    action();
  });

  await Future.delayed(duration, () {
    timer.cancel();
  });
}
