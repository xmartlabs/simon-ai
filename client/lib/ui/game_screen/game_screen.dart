import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/extensions/context_extensions.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:design_system/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/common/dashed_stadium_border.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

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
  Widget build(BuildContext context) => AppScaffold(
        showBackButton: false,
        child: Stack(
          children: [
            SizedBox(
              width: 1.sw,
              height: 1.sh,
            ),
            Align(
              child: Opacity(
                opacity: .5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: context.theme.colorScheme.surface.getShade(400),
                  ),
                  width: .8.sw,
                  height: .8.sh,
                  child: const _CameraLiveView(),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topRight,
              child: _Points(),
            ),
          ],
        ),
      );
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
      setState(() {});
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
    return Container(
      margin: const EdgeInsets.all(42),
      padding: const EdgeInsets.all(8),
      decoration: ShapeDecoration(
        shape: DashedStadiumBorder(
          side: BorderSide(
            color: context.theme.colorScheme.surfaceBright,
            width: 2,
          ),
        ),
      ),
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
        ),
      ),
    );
  }
}
