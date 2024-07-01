import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:design_system/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/common/dashed_stadium_border.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';
import 'package:simon_ai/ui/game_screen/game_state_screens/finish_game_screen.dart';
import 'package:simon_ai/ui/game_screen/game_state_screens/playing_screen.dart';
import 'package:simon_ai/ui/game_screen/game_state_screens/show_sequence_screen.dart';

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
                  child: _CameraLiveView(),
                ),
              switch (state.gameState) {
                GameState.initial => const Align(child: GameOverlay()),
                GameState.countDown => const Align(child: GameOverlay()),
                GameState.showingSequence => const Align(child: GameOverlay()),
                GameState.playing => const PlayingGameScreen(),
                GameState.ended => const FinishGameScreen()
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

class GameOverlay extends StatefulWidget {
  const GameOverlay({
    super.key,
  });

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  late final Timer _timer;
  int _counter = 3;
  bool startGame = false;

  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () {
        context.read<GameScreenCubit>().startCountdown();
        _timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            setState(() {
              _counter--;
            });
            if (_counter == 0) {
              timer.cancel();
              context.read<GameScreenCubit>().startSequence();
            }
          },
        );
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
  Widget build(BuildContext context) {
    final GameState gameState = context.select(
      (GameScreenCubit cubit) => cubit.state.gameState,
    );

    final localizations = context.localizations;
    final headlineLarge = context.theme.textStyles.headlineLarge;
    return Opacity(
      opacity: .7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: context.theme.colorScheme.surface.getShade(400),
        ),
        width: .8.sw,
        height: .8.sh,
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
            GameState.countDown => Text(
                '$_counter',
                style: headlineLarge!.copyWith(
                  fontSize: 120,
                ),
              ),
            _ => Container(),
          },
        ),
      ),
    );
  }
}

class _CameraLiveView extends StatefulWidget {
  const _CameraLiveView({
    super.key,
  });

  @override
  State<_CameraLiveView> createState() => _CameraLiveViewState();
}

class _CameraLiveViewState extends State<_CameraLiveView> {
  CameraController? _cameraController;

  @override
  void initState() {
    aux();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  Future<void> aux() async {
    final list = await availableCameras();
    _cameraController = CameraController(
      list.firstWhere(
        (elem) => elem.lensDirection == CameraLensDirection.front,
      ),
      ResolutionPreset.max,
    );
    await _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cameraController = _cameraController;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }
    return Transform.scale(
      scaleX: .92,
      scaleY: .85,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: CameraPreview(
          _cameraController!,
        ),
      ),
    );
  }
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
