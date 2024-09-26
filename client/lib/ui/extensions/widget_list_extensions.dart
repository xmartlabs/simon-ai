import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension WidgetListExtension on List<Widget> {
  AnimateList<Widget> get fadeInAnimation => animate(
        interval: 100.ms,
      )
          .fadeIn(
            duration: 400.ms,
            curve: Curves.easeIn,
          )
          .slideY(
            duration: 300.ms,
            begin: -.5,
            curve: Curves.easeOut,
          );
}
