import 'dart:ui';

typedef Coordinates = ({
  double x,
  double y,
});

extension CoordinatesExtension on Coordinates {
  Offset getOffset({required Size canvasSize, required Size imageSize}) =>
      Offset(
        x / imageSize.width * canvasSize.width,
        y / imageSize.height * canvasSize.height,
      );
}

extension ListCoordinatesExtension on List<Coordinates> {
  Coordinates get centerCoordinates {
    if (isEmpty) {
      throw ArgumentError('The coordinates list cannot be empty');
    }

    double sumX = 0;
    double sumY = 0;

    for (final coordinate in this) {
      sumX += coordinate.x;
      sumY += coordinate.y;
    }

    final double centerX = sumX / length;
    final double centerY = sumY / length;

    return (x: centerX, y: centerY);
  }
}
