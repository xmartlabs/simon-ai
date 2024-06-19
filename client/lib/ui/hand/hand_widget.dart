import 'package:flutter/widgets.dart';
import 'package:simon_ai/ui/hand/hand_model_widget.dart';
import 'package:simon_ai/ui/hand/hand_widget_mobile.dart';

class HandWidget extends StatefulWidget with HandModelWidget {
  final double width;
  final double height;
  @override
  final Stream<dynamic> movenetStream;

  HandWidget({
    required this.width,
    required this.height,
    required this.movenetStream,
    super.key,
  });

  @override
  HandPlatformWidgetState createState() => HandPlatformWidgetState();
}
