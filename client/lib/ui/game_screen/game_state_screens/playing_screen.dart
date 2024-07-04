import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

class PlayingGameScreen extends StatefulWidget {
  const PlayingGameScreen({super.key});

  @override
  State<PlayingGameScreen> createState() => _PlayingGameScreenState();
}

class _PlayingGameScreenState extends State<PlayingGameScreen> {
  late final Timer timer;

  @override
  void initState() {
    timer = Timer(
      const Duration(seconds: 5),
      context.read<GameScreenCubit>().startCountdown,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container();
}
