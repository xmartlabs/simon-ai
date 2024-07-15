import 'dart:ui';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/hand_models/hand_tracking/hand_tracking_points.dart';
import 'package:simon_ai/core/hand_models/keypoints/keypoints_manager_mobile.dart';

class HandRenderPainter extends CustomPainter {
  static const _drawKeypoints = Config.debugMode;
  static const _scoreThreshold = 0.6;

  late Size imageSize;
  late HandLandmarksData keypointsData;

  final _pointGreen = Paint()
    ..color = Colors.green
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  final _edge = Paint()
    ..color = const Color(0xFFA1E0E3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6;

  final _drawableBodyEdges = [
    const Pair(HandLandmark.wrist, HandLandmark.thumbCmc),
    const Pair(HandLandmark.thumbCmc, HandLandmark.thumbMcp),
    const Pair(HandLandmark.thumbMcp, HandLandmark.thumbIp),
    const Pair(HandLandmark.thumbIp, HandLandmark.thumbTip),
    const Pair(HandLandmark.wrist, HandLandmark.indexFingerMcp),
    const Pair(HandLandmark.indexFingerMcp, HandLandmark.indexFingerPip),
    const Pair(HandLandmark.indexFingerPip, HandLandmark.indexFingerDip),
    const Pair(HandLandmark.indexFingerDip, HandLandmark.indexFingerTip),
    const Pair(HandLandmark.indexFingerMcp, HandLandmark.middleFingerMcp),
    const Pair(HandLandmark.middleFingerMcp, HandLandmark.middleFingerPip),
    const Pair(HandLandmark.middleFingerPip, HandLandmark.middleFingerDip),
    const Pair(HandLandmark.middleFingerDip, HandLandmark.middleFingerTip),
    const Pair(HandLandmark.middleFingerMcp, HandLandmark.ringFingerMcp),
    const Pair(HandLandmark.ringFingerMcp, HandLandmark.ringFingerPip),
    const Pair(HandLandmark.ringFingerPip, HandLandmark.ringFingerDip),
    const Pair(HandLandmark.ringFingerDip, HandLandmark.ringFingerTip),
    const Pair(HandLandmark.ringFingerMcp, HandLandmark.pinkyMcp),
    const Pair(HandLandmark.wrist, HandLandmark.pinkyMcp),
    const Pair(HandLandmark.pinkyMcp, HandLandmark.pinkyPip),
    const Pair(HandLandmark.pinkyPip, HandLandmark.pinkyDip),
    const Pair(HandLandmark.pinkyDip, HandLandmark.pinkyTip),
  ];

  HandRenderPainter({required this.keypointsData, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    if (keypointsData.confidence > _scoreThreshold) {
      if (keypointsData.keyPoints.length == HandLandmark.values.length) {
        drawBody(canvas, size, _edge);
      }
      if (_drawKeypoints) {
        drawKeyPoints(canvas, size);
      }
    }
  }

  void drawKeyPoints(Canvas canvas, Size size) {
    final pointsGreen = <Offset>[];
    for (final point in keypointsData.keyPoints) {
      pointsGreen.add(point.getOffset(canvasSize: size, imageSize: imageSize));
    }
    canvas.drawPoints(PointMode.points, pointsGreen, _pointGreen);
  }

  @override
  bool shouldRepaint(covariant HandRenderPainter oldDelegate) =>
      keypointsData != oldDelegate.keypointsData;

  void drawBodyLine(
    Canvas canvas,
    Size size,
    Pair<HandLandmark, HandLandmark> line,
    Paint paint,
  ) {
    canvas.drawLine(
      keypointsData.keyPoints[line.first.index]
          .getOffset(canvasSize: size, imageSize: imageSize),
      keypointsData.keyPoints[line.second.index]
          .getOffset(canvasSize: size, imageSize: imageSize),
      paint,
    );
  }

  void drawBody(Canvas canvas, Size size, Paint paint) {
    for (final points in _drawableBodyEdges) {
      drawBodyLine(canvas, size, Pair(points.first, points.second), paint);
    }
  }
}
