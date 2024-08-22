import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simon_ai/core/model/hand_landmarks_result_data.dart';

mixin HandModelWidget implements StatefulWidget {
  abstract final Stream<dynamic>? movenetStream;
}

mixin HandModelWidgetState<T extends HandModelWidget>
    implements State<T>, WidgetsBindingObserver {
  StreamSubscription? _keypointsSubscription;

  HandLandmarksData? keypoints;

  void _initKeypointsStream() {
    final stream = widget.movenetStream;
    if (stream != null &&
        (_keypointsSubscription == null || _keypointsSubscription!.isPaused)) {
      _keypointsSubscription = stream.listen((keypoints) {
        setState(() {
          this.keypoints = keypoints;
        });
      });
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await _keypointsSubscription?.cancel();
        break;
      case AppLifecycleState.resumed:
        _initKeypointsStream();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
