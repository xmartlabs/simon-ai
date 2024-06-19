import 'package:dartx/dartx.dart';
import 'package:design_system/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:simon_ai/ui/hand/hand_render_painter.dart';
import 'package:simon_ai/ui/hand/hand_model_widget.dart';
import 'package:simon_ai/ui/hand/hand_widget.dart';

class HandPlatformWidgetState extends State<HandWidget>
    with HandModelWidgetState<HandWidget> {
  @override
  Widget build(BuildContext context) => Container(
        // padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        height: widget.height,
        width: widget.width,
        child: CustomPaint(
          foregroundPainter:
              HandRenderPainter(keypoints ?? const Pair(0.0, [])),
        ),
      );
}
