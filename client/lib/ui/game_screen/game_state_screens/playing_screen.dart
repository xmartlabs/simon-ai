import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      BlocBuilder<CameraHandCubit, CameraHandState>(
        builder: (context, state) => Transform.scale(
          scaleX: .92,
          scaleY: .85,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: CameraWidget(
              width: 1.sw,
              height: 1.sh,
              enableBorderRadius: true,
              onNewFrame: (dynamic frame) =>
                  context.read<CameraHandCubit>().onNewFrame(frame),
              movenetStream: state.movenetResultStream,
              showGesture: showGesture,
            ),
          ),
        ),
      );
}
