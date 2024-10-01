import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class DashedStadiumBorder extends StadiumBorder {
  DashedStadiumBorder({
    CircularIntervalList<double>? dashArray,
    this.inset = false,
    super.side,
  }) : dashArray = dashArray ??
            CircularIntervalList<double>(
              <double>[18 * side.width, 8 * side.width],
            );

  const DashedStadiumBorder.inset({
    required this.dashArray,
    super.side,
  }) : inset = true;

  final CircularIntervalList<double> dashArray;

  final bool inset;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(inset ? 0.0 : side.width);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        if (inset) {
          rect = rect.deflate(side.width);
        }
        final Radius radius = Radius.circular(rect.shortestSide / 16.0);
        final rrect = RRect.fromRectAndRadius(rect, radius);
        canvas.drawPath(
          dashPath(Path()..addRRect(rrect), dashArray: dashArray),
          side.toPaint(),
        );
    }
  }
}
