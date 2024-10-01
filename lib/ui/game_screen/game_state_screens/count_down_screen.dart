import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

class CountDownScreen extends StatefulWidget {
  const CountDownScreen({
    super.key,
  });

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  late Timer _timer;
  int _counter = 3;

  @override
  void initState() {
    context.read<GameScreenCubit>().startCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          _counter--;
        });
        if (_counter <= 0) {
          context.read<GameScreenCubit>().startNewSequence();
          timer.cancel();
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
        '$_counter',
        style: context.theme.textStyles.headlineLarge!.copyWith(
          fontSize: 120,
        ),
      );
}
