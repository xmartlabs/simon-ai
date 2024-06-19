import 'package:flutter/material.dart';
import 'package:simon_ai/ui/hand/hand_model_widget.dart';
import 'package:simon_ai/ui/widgets/camera/camera_mobile_widget.dart'
    if (dart.library.html) 'package:simon_ai/ui/widgets/camera/camera_web_widget.dart';

class CameraWidget extends StatefulWidget with HandModelWidget {
  final double width;
  final double height;
  final bool enableBorderRadius;
  final ValueChanged<dynamic> onNewFrame;
  @override
  final Stream<dynamic>? movenetStream;

  const CameraWidget({
    required this.width,
    required this.height,
    required this.enableBorderRadius,
    required this.onNewFrame,
    this.movenetStream,
    super.key,
  });

  @override
  CameraPlatformWidgetState createState() => CameraPlatformWidgetState();
}
