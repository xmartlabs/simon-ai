import 'package:design_system/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:simon_ai/ui/hand/hand_render_painter.dart';
import 'package:simon_ai/ui/hand/hand_model_widget.dart';
import 'package:simon_ai/ui/hand/hand_drawing_widget.dart';

class HandPlatformWidgetState extends State<HandDrawingWidget>
    with HandModelWidgetState<HandDrawingWidget> {
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        height: widget.height,
        width: widget.width,
        child: CustomPaint(
          foregroundPainter: HandRenderPainter(
            keypoints ?? const (confidence: 0.0, keyPoints: []),
          ),
        ),
      );
}
