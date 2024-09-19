// ignore_for_file: unused_field

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/model/hand_landmarks_result_data.dart';
import 'package:simon_ai/ui/extensions/camera_extensions.dart';
import 'package:simon_ai/ui/hand/hand_render_painter.dart';
import 'package:simon_ai/ui/widgets/camera/camera_widget.dart';

class CameraPlatformWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  final resolutionPreset = Config.cameraResolutionPreset;
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
    _cameraController?.stopImageStream();
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _loadCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.lastWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      ),
      resolutionPreset,
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
        await _cameraController?.stopImageStream();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: widget.gestureStream,
        builder: (context, snapshot) => (!snapshot.hasData ||
                _cameraController == null ||
                !_cameraController!.value.isInitialized)
            ? Container()
            : _GestureSection(
                resolutionPreset: resolutionPreset,
                cameraController: _cameraController,
                showGesture: widget.showGesture,
                gestureData: snapshot.data,
              ),
      );
}

class _GestureSection extends StatelessWidget {
  final ResolutionPreset resolutionPreset;
  final CameraController? cameraController;
  final HandLandmarksData? gestureData;
  final bool showGesture;

  const _GestureSection({
    required this.resolutionPreset,
    required this.cameraController,
    required this.gestureData,
    required this.showGesture,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        child: showGesture
            ? CustomPaint(
                foregroundPainter: HandRenderPainter(
                  keypointsData: gestureData ??
                      (
                        confidence: 0.0,
                        keyPoints: [],
                        gesture: HandGesture.unrecognized,
                        cropData: (x: 0, y: 0, w: 0, h: 0, confidence: 0.0),
                      ),
                  imageSize: resolutionPreset
                      .sizeForOrientation(MediaQuery.of(context).orientation),
                ),
                child: CameraPreview(cameraController!),
              )
            : CameraPreview(cameraController!),
      );
}
