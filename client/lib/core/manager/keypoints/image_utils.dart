import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:simon_ai/core/common/logger.dart';

class ImageUtils {
  /// Converts a [CameraImage] in YUV420 format to [img.Image] in RGB format
  static img.Image? convertCameraImage(CameraImage cameraImage) {
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      return convertYUV420ToImage(cameraImage);
    } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      return convertBGRA8888ToImage(cameraImage);
    } else {
      return null;
    }
  }

  /// Converts a [CameraImage] in BGRA888 format to [img.Image] in RGB format
  static img.Image convertBGRA8888ToImage(CameraImage cameraImage) =>
      img.Image.fromBytes(
        width: cameraImage.planes.first.width!,
        height: cameraImage.planes.first.height!,
        bytes: cameraImage.planes.first.bytes.buffer,
        order: img.ChannelOrder.bgra,
      );

  /// Converts a [CameraImage] in YUV420 format to [img.Image] in RGB format
  static img.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: width, height: height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final index = h * width + w;

        final y = cameraImage.planes.first.bytes[index];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        image.setPixelRgb(w, h, r, g, b);
      }
    }
    return image;
  }

  /// Convert a single YUV pixel to RGB
  static int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  static Future<void> saveImage(img.Image image, [int i = 0]) async {
    final jpeg = img.encodeJpg(image);
    final appDir = await getTemporaryDirectory();
    final appPath = appDir.path;
    final fileOnDevice = File('$appPath/out$i.jpg');
    await fileOnDevice.writeAsBytes(jpeg, flush: true);
    if (kDebugMode) {
      Logger.d('Saved $appPath/out$i.jpg');
    }
  }

  static img.Image getProcessedImage(img.Image inputImage, int modelInputSize) {
    final padSize = max(inputImage.height, inputImage.width);

    final paddedImage = img.Image(width: padSize, height: padSize);

    final int offsetX = (padSize - inputImage.width) ~/ 2;
    final int offsetY = (padSize - inputImage.height) ~/ 2;

    for (int x = 0; x < inputImage.width; x++) {
      for (int y = 0; y < inputImage.height; y++) {
        final int paddedX = x + offsetX;
        final int paddedY = y + offsetY;
        if (paddedX < paddedImage.width && paddedY < paddedImage.height) {
          final pixel = inputImage.getPixelSafe(x, y);
          final color = img.ColorFloat16.rgba(
            pixel.r.toInt(),
            pixel.g.toInt(),
            pixel.b.toInt(),
            pixel.a.toInt(),
          );
          paddedImage.setPixel(paddedX, paddedY, color);
        } else {
          throw ArgumentError(
            'Pixel coordinates are out of bounds for the padded image.',
          );
        }
      }
    }
    return img.copyResize(
      paddedImage,
      width: modelInputSize,
      height: modelInputSize,
    );
  }
}
