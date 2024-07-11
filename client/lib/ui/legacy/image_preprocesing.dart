import 'package:image/image.dart';

extension ImagePreprocessing on Image {
  List<List<List<double>>> toMatrix() => List.generate(
        height,
        (y) => List.generate(
          width,
          (x) {
            final pixel = getPixel(x, y);
            // Normalize pixel values to [0, 1]
            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          },
        ),
      );
}
