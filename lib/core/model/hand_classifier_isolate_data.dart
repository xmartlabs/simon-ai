import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:simon_ai/core/model/anchor.dart';

/// Bundles data to pass between Isolate
typedef HandClassifierIsolateData = ({
  CameraImage cameraImage,
  List<int> interpreterAddressList,
  List<Anchor> anchors,
  int processorIndex,
  SendPort responsePort,
});
