import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/ui/extensions/camera_extensions.dart';

class GestureFeedback extends StatefulWidget {
  final List<HandGestureWithPosition> handGestureHistoryStream;

  const GestureFeedback({required this.handGestureHistoryStream, super.key});

  @override
  GestureFeedbackState createState() => GestureFeedbackState();
}

class GestureFeedbackState extends State<GestureFeedback>
    with SingleTickerProviderStateMixin {
  bool _showCheckIcon = false;
  HandGestureWithPosition? currentGesture;
  AnimationController? _controller;
  Animation<double>? _animation;

  final Duration _animationDuration = const Duration(milliseconds: 600);

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
  }

  @override
  void didUpdateWidget(covariant GestureFeedback oldWidget) {
    if (oldWidget.handGestureHistoryStream != widget.handGestureHistoryStream) {
      currentGesture = widget.handGestureHistoryStream.last;
      _showGestureFeedback();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _showGestureFeedback() {
    setState(() {
      _showCheckIcon = true;
    });

    _controller?.forward(from: 0).then((_) {
      setState(() {
        _showCheckIcon = false;
      });
    });
  }

  (double animationValue, double left, double top, double size)
      calculateAnimationPosition(BoxConstraints constraints) {
    final boxTopLeft = currentGesture!.boundingBox;

    final orientation = MediaQuery.of(context).orientation;
    final cameraResolutionSize =
        Config.cameraResolutionPreset.sizeForOrientation(orientation);
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;
    final double initialLeft =
        boxTopLeft.x / cameraResolutionSize.width * maxWidth;
    final double initialTop =
        boxTopLeft.y / cameraResolutionSize.height * maxHeight;
    final double initialSize =
        boxTopLeft.w / cameraResolutionSize.width * maxWidth;

    final double finalLeft = (maxWidth - maxHeight) / 2;
    const double finalTop = 0;
    final double finalSize = maxHeight;
    final double animationValue = _animation!.value;
    final double left =
        initialLeft * (1 - animationValue) + finalLeft * animationValue;
    final double top =
        initialTop * (1 - animationValue) + finalTop * animationValue;
    final double size =
        initialSize * (1 - animationValue) + finalSize * animationValue;
    return (animationValue, left, top, size);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            if (_showCheckIcon)
              AnimatedBuilder(
                animation: _animation!,
                builder: (context, child) {
                  final (animationValue, left, top, size) =
                      calculateAnimationPosition(constraints);
                  return Positioned(
                    left: left,
                    top: top,
                    child: AnimatedOpacity(
                      opacity: 1 - animationValue,
                      duration: _animationDuration,
                      child: SizedBox(
                        width: size,
                        height: size,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _GestureWidget(
                              currentGesture: currentGesture,
                              size: size,
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
      );
}

class _GestureWidget extends StatelessWidget {
  const _GestureWidget({
    required this.currentGesture,
    required this.size,
    super.key,
  });

  final HandGestureWithPosition? currentGesture;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (Config.halloweenMode &&
        currentGesture?.gesture.halloweenEmoji != null) {
      return currentGesture!.gesture.halloweenEmoji!.image();
    } else {
      return Text(
        currentGesture?.gesture.emoji ?? '',
        style: context.theme.textStyles.headlineLarge!.copyWith(
          fontSize: size / 1.6,
        ),
      );
    }
  }
}
