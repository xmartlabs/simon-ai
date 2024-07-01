import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

class ShowSequenceScreen extends StatefulWidget {
  const ShowSequenceScreen({
    super.key,
  });

  @override
  State<ShowSequenceScreen> createState() => _ShowSequenceScreenState();
}

class _ShowSequenceScreenState extends State<ShowSequenceScreen> {
  late final Timer sequenceTimer;
  late final Timer yourTurnTimer;
  int _currentSequenceIndex = 0;
  bool showYourTurn = false;

  @override
  void initState() {
    sequenceTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        setState(() {
          _currentSequenceIndex++;
        });
        if (_currentSequenceIndex ==
            context.read<GameScreenCubit>().state.currentSequence!.length - 1) {
          sequenceTimer.cancel();
          setState(() {
            showYourTurn = true;
          });
          yourTurnTimer = Timer(
            const Duration(seconds: 3),
            () {
              context.read<GameScreenCubit>().startGame();
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    sequenceTimer.cancel();
    yourTurnTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HandGesutre? currentHandValue = context.select(
      (GameScreenCubit cubit) => cubit.state.currentHandValue,
    );

    final headlineLarge = context.theme.textStyles.headlineLarge;

    return Text(
      showYourTurn ? context.localizations.your_turn : currentHandValue ?? '',
      style: headlineLarge!.copyWith(
        fontSize: 120,
      ),
    );
  }
}
