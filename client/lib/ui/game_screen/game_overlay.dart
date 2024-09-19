import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/ui/common/dashed_stadium_border.dart';
import 'package:simon_ai/ui/extensions/camera_extensions.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';
import 'package:simon_ai/ui/game_screen/game_state_screens/count_down_screen.dart';
import 'package:simon_ai/ui/game_screen/game_state_screens/show_sequence_screen.dart';

class GameOverlay extends StatelessWidget {
  const GameOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GameState gameState = context.select(
      (GameScreenCubit cubit) => cubit.state.gameState,
    );

    final localizations = context.localizations;
    final headlineLarge = context.theme.textStyles.headlineLarge;
    final inversedAspectRatio = Config.cameraResolutionPreset
        .sizeForOrientation(Orientation.landscape)
        .aspectRatio;
    return OrientationBuilder(
      builder: (context, orientation) => Transform.scale(
        scaleX: .92,
        scaleY: .85,
        child: LayoutBuilder(
          builder: (context, constraints) => Opacity(
            opacity: .7,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: context.theme.colorScheme.surface.getShade(400),
              ),
              height: orientation == Orientation.portrait
                  ? constraints.maxWidth * inversedAspectRatio
                  : null,
              width: orientation == Orientation.landscape
                  ? constraints.maxHeight *
                      Config.cameraResolutionPreset
                          .sizeForOrientation(orientation)
                          .aspectRatio
                  : null,
              child: Container(
                margin: const EdgeInsets.all(42),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  shape: DashedStadiumBorder(
                    side: BorderSide(
                      color: context.theme.colorScheme.surfaceBright,
                      width: 2,
                    ),
                  ),
                ),
                child: switch (gameState) {
                  GameState.initial => Text(
                      localizations.game_position_hands,
                      style: headlineLarge!,
                    ),
                  GameState.showingSequence => const ShowSequenceScreen(),
                  GameState.countDown => const CountDownScreen(),
                  _ => Container(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
