import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:design_system/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/gen/assets.gen.dart';
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
                  child: PlayingGameScreen(),
                ),
              switch (state.gameState) {
                GameState.initial => const Align(child: GameOverlay()),
                GameState.countDown => const Align(child: GameOverlay()),
                GameState.showingSequence => const Align(child: GameOverlay()),
                GameState.playing => Container(),
                GameState.ended => const FinishGameScreen(),
                GameState.error => const ErrorStateScreen(),
              },
              if (state.gameState != GameState.ended)
                const Align(
                  alignment: Alignment.topRight,
                  child: _Points(),
                ),
              if (state.gameState != GameState.ended)
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Assets.images.check.image(
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.localizations
                            .correct_gestures(state.currentHandValueIndex ?? 0),
                        style: context.theme.textStyles.headlineSmall!
                            .bold()
                            .copyWith(
                              color: context.theme.customColors.textColor,
                            ),
                      ),
                    ],
                  ),
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
