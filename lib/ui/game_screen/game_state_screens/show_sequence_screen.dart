import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

import 'package:simon_ai/core/common/config.dart';

class ShowSequenceScreen extends StatefulWidget {
  const ShowSequenceScreen({
    super.key,
  });

  @override
  State<ShowSequenceScreen> createState() => _ShowSequenceScreenState();
}

class _ShowSequenceScreenState extends State<ShowSequenceScreen> {
  late final Timer yourTurnTimer;
  late final Stream<HandGesture> sequenceStream;

  @override
  void initState() {
    sequenceStream = context.read<GameScreenCubit>().sequenceStream;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialGesture = context.select(
      (GameScreenCubit cubit) => cubit.state.currentHandValue,
    );
    final currentRound = context.read<GameScreenCubit>().state.currentRound;
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (context, snapshot) => (snapshot.connectionState ==
              ConnectionState.waiting)
          ? Center(
              child: Text(
                context.localizations.round(currentRound),
                style: context.theme.textStyles.headlineLarge!.copyWith(
                  fontSize: 60,
                ),
              ),
            )
          : StreamBuilder<HandGesture>(
              stream: sequenceStream,
              initialData: initialGesture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (Config.halloweenMode &&
                      snapshot.data?.halloweenEmoji != null) {
                    return snapshot.data!.halloweenEmoji!.image();
                  } else {
                    return Text(
                      snapshot.data?.emoji ?? '',
                      style: context.theme.textStyles.headlineLarge!.copyWith(
                        fontSize: 150,
                      ),
                    );
                  }
                }

                return const SizedBox();
              },
            ),
    );
  }
}
