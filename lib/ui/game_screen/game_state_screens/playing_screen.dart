import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/camera_hand/camera_hand_cubit.dart';
import 'package:simon_ai/ui/widgets/camera/camera_widget.dart';

class PlayingGameScreen extends StatelessWidget {
  final bool showGesture;
  const PlayingGameScreen({required this.showGesture, super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => CameraHandCubit(),
        child: _CameraContent(
          showGesture: showGesture,
        ),
      );
}

class _CameraContent extends StatelessWidget {
  final bool showGesture;
  const _CameraContent({
    required this.showGesture,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      BlocSelector<CameraHandCubit, CameraHandState, Stream<dynamic>?>(
        selector: (state) => state.gestureStream,
        builder: (context, stream) => Transform.scale(
          scaleX: .92,
          scaleY: .85,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: CameraWidget(
              enableBorderRadius: true,
              onNewFrame: (dynamic frame) =>
                  context.read<CameraHandCubit>().onNewFrame(frame),
              gestureStream: stream,
              showGesture: showGesture,
            ),
          ),
        ),
      );
}
