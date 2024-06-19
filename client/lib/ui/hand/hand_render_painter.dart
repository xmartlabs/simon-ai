import 'dart:ui';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/manager/keypoints/movenet_points.dart';

class HandRenderPainter extends CustomPainter {
  static const _drawKeypoints = Config.debugMode;
  static const _scoreThreshold = 0.6;

  late Pair<double, List<KeyPointData>> keypoints;
  late double confidence;
  late PointMode pointMode;

  var pointGreen = Paint()
    ..color = Colors.green
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  var edge = Paint()
    ..color = const Color(0xFFA1E0E3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6;

  static const _drawableBodyEdges = [
    Pair(HandLandmark.wrist, HandLandmark.thumbCmc),
    Pair(HandLandmark.thumbCmc, HandLandmark.thumbMcp),
    Pair(HandLandmark.thumbMcp, HandLandmark.thumbIp),
    Pair(HandLandmark.thumbIp, HandLandmark.thumbTip),
    Pair(HandLandmark.wrist, HandLandmark.indexFingerMcp),
    Pair(HandLandmark.indexFingerMcp, HandLandmark.indexFingerPip),
    Pair(HandLandmark.indexFingerPip, HandLandmark.indexFingerDip),
    Pair(HandLandmark.indexFingerDip, HandLandmark.indexFingerTip),
    Pair(HandLandmark.indexFingerMcp, HandLandmark.middleFingerMcp),
    Pair(HandLandmark.middleFingerMcp, HandLandmark.middleFingerPip),
    Pair(HandLandmark.middleFingerPip, HandLandmark.middleFingerDip),
    Pair(HandLandmark.middleFingerDip, HandLandmark.middleFingerTip),
    Pair(HandLandmark.middleFingerMcp, HandLandmark.ringFingerMcp),
    Pair(HandLandmark.ringFingerMcp, HandLandmark.ringFingerPip),
    Pair(HandLandmark.ringFingerPip, HandLandmark.ringFingerDip),
    Pair(HandLandmark.ringFingerDip, HandLandmark.ringFingerTip),
    Pair(HandLandmark.ringFingerMcp, HandLandmark.pinkyMcp),
    Pair(HandLandmark.wrist, HandLandmark.pinkyMcp),
    Pair(HandLandmark.pinkyMcp, HandLandmark.pinkyPip),
    Pair(HandLandmark.pinkyPip, HandLandmark.pinkyDip),
    Pair(HandLandmark.pinkyDip, HandLandmark.pinkyTip),
  ];

  HandRenderPainter(this.keypoints);

  @override
  void paint(Canvas canvas, Size size) {
    if (keypoints.first > _scoreThreshold) {
      if (keypoints.second.length == HandLandmark.values.length) {
        drawBody(canvas, size, edge);
      }
      if (_drawKeypoints) {
        drawKeyPoints(canvas, size);
      }
    }
  }

  void drawKeyPoints(Canvas canvas, Size size) {
    final pointsGreen = <Offset>[];
    for (final point in keypoints.second) {
      pointsGreen.add(point.getOffset(size));
    }
    canvas.drawPoints(PointMode.points, pointsGreen, pointGreen);
  }

  @override
  bool shouldRepaint(covariant HandRenderPainter oldDelegate) =>
      keypoints != oldDelegate.keypoints;

  void drawBodyLine(
    Canvas canvas,
    Size size,
    HandLandmark start,
    HandLandmark end,
    Paint paint,
  ) {
    canvas.drawLine(
      keypoints.second[start.index].getOffset(size),
      keypoints.second[end.index].getOffset(size),
      paint,
    );
  }

  void drawBody(Canvas canvas, Size size, Paint paint) {
    for (final points in _drawableBodyEdges) {
      drawBodyLine(canvas, size, points.first, points.second, paint);
    }
  }
}

extension MoveNetPointDataExtensions on KeyPointData {
  Offset getOffset(Size size) => Offset(x, y);
}
