import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager_mobile.dart';

mixin HandModelWidget implements StatefulWidget {
  abstract final Stream<dynamic>? movenetStream;
}

mixin HandModelWidgetState<T extends HandModelWidget> implements State<T> {
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
  void initState() => _initKeypointsStream();

  @override
  void didUpdateWidget(covariant HandModelWidget oldWidget) =>
      _initKeypointsStream();

  @override
  void dispose() => _keypointsSubscription?.cancel();
}
