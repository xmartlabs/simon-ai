// ignore_for_file: unused_field

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/ui/hand/hand_render_painter.dart';
import 'package:simon_ai/ui/hand/hand_model_widget.dart';
import 'package:simon_ai/ui/widgets/camera/camera_widget.dart';

class CameraPlatformWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver, HandModelWidgetState<CameraWidget> {
  CameraController? _cameraController;

  CameraPlatformWidgetState();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _loadCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _loadCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.lastWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      ),
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.unknown,
    );
    await _cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        _cameraController!.startImageStream(widget.onNewFrame);
        // ignore: no-empty-block
        setState(() {
          // Camera initialized and started streaming
        });
      }
    }).catchError((Object e) {
      Logger.w(e, 'Camera initialization error');
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        await _cameraController?.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (_cameraController != null &&
            !_cameraController!.value.isStreamingImages) {
          await _cameraController!.startImageStream(widget.onNewFrame);
        }
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }
    return CustomPaint(
      foregroundPainter:
          HandRenderPainter(keypoints ?? (confidence: 0.0, keyPoints: [])),
      child: CameraPreview(_cameraController!),
    );
  }
}
