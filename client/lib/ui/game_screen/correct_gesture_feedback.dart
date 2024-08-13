import 'package:camera/camera.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/ui/extensions/camera_extensions.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

class CorrectGestureFeedback extends StatefulWidget {
  const CorrectGestureFeedback({super.key});

  @override
  CorrectGestureFeedbackState createState() => CorrectGestureFeedbackState();
}

class CorrectGestureFeedbackState extends State<CorrectGestureFeedback>
    with SingleTickerProviderStateMixin {
  bool _showCheckIcon = false;
  HandGestureWithPosition? currentGesture;
  AnimationController? _controller;
  Animation<double>? _animation;

  final Duration _animationDuration = const Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );
    context
        .read<GameScreenCubit>()
        .stream
        .map((state) => state.handSequenceHistory)
        .distinct()
        .skip(1)
        .listen((currentHandValue) {
      currentGesture = currentHandValue!.last;
      _showCheckIconForTwoSeconds();
    });
  }

  void _showCheckIconForTwoSeconds() {
    setState(() {
      _showCheckIcon = true;
    });

    _controller?.forward(from: 0).then((_) {
      setState(() {
        _showCheckIcon = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Transform.scale(
        scaleX: .92,
        scaleY: .85,
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              if (_showCheckIcon)
                AnimatedBuilder(
                  animation: _animation!,
                  builder: (context, child) {
                    final double initialLeft = currentGesture!.box.x /
                        ResolutionPreset.medium.size.width *
                        constraints.maxWidth;
                    final double initialTop = currentGesture!.box.y /
                        ResolutionPreset.medium.size.height *
                        constraints.maxHeight;
                    final double initialSize = currentGesture!.box.w /
                        ResolutionPreset.medium.size.width *
                        constraints.maxWidth;

                    final double finalLeft =
                        (constraints.maxWidth - constraints.maxHeight) / 2;
                    const double finalTop = 0;
                    final double finalSize = constraints.maxHeight;

                    final double left = initialLeft * (1 - _animation!.value) +
                        finalLeft * _animation!.value;
                    final double top = initialTop * (1 - _animation!.value) +
                        finalTop * _animation!.value;
                    final double size = initialSize * (1 - _animation!.value) +
                        finalSize * _animation!.value;

                    return Positioned(
                      left: left,
                      top: top,
                      child: AnimatedOpacity(
                        opacity: 1 - _animation!.value,
                        duration: _animationDuration,
                        child: SizedBox(
                          width: size,
                          height: size,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentGesture?.gesture.emoji ?? '',
                                style: context.theme.textStyles.headlineLarge!
                                    .copyWith(
                                  fontSize: size / 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      );
}
