import 'package:flutter/material.dart';
import 'package:simon_ai/ui/widgets/camera/camera_mobile_widget.dart'
    if (dart.library.html) 'package:simon_ai/ui/widgets/camera/camera_web_widget.dart';

class CameraWidget extends StatefulWidget {
  final bool enableBorderRadius;
  final bool showGesture;
  final ValueChanged<dynamic> onNewFrame;
  final Stream<dynamic>? gestureStream;

  const CameraWidget({
    required this.enableBorderRadius,
    required this.onNewFrame,
    required this.showGesture,
    this.gestureStream,
    super.key,
  });

  @override
  CameraPlatformWidgetState createState() => CameraPlatformWidgetState();
}
