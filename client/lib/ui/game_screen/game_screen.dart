import 'package:auto_route/auto_route.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:design_system/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/game_screen/camera_live_view.dart';
import 'package:simon_ai/ui/game_screen/game_overlay.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';
import 'package:simon_ai/ui/game_screen/game_state_screens/error_state_screen.dart';
import 'package:simon_ai/ui/game_screen/game_state_screens/finish_game_screen.dart';
import 'package:simon_ai/ui/game_screen/game_state_screens/playing_screen.dart';

@RoutePage()
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => GameScreenCubit(),
        child: const _GameScreenContent(),
      );
}

class _GameScreenContent extends StatelessWidget {
  const _GameScreenContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GameScreenCubit, GameScreenState>(
        builder: (context, state) => AppScaffold(
          showBackButton: false,
          child: Stack(
            children: [
              if (state.gameState != GameState.ended)
                const Align(
                  alignment: Alignment.center,
                  child: CameraLiveView(),
                ),
              switch (state.gameState) {
                GameState.initial => const Align(child: GameOverlay()),
                GameState.countDown => const Align(child: GameOverlay()),
                GameState.showingSequence => const Align(child: GameOverlay()),
                GameState.playing => const PlayingGameScreen(),
                GameState.ended => const FinishGameScreen(),
                GameState.error => const ErrorStateScreen(),
              },
              if (state.gameState != GameState.ended)
                const Align(
                  alignment: Alignment.topRight,
                  child: _Points(),
                ),
            ],
          ),
        ),
      );
}

class _Points extends StatelessWidget {
  const _Points({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final points = context.watch<GameScreenCubit>().state.currentPoints;
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: SizedBox(
        width: .15.sw,
        child: InformationSummary(
          type: InformationSummaryType.points,
          value: points,
          showBorder: false,
        ),
      ),
    );
  }
}