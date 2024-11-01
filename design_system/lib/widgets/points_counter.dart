import 'package:design_system/extensions/context_extensions.dart';
import 'package:design_system/gen/assets.gen.dart';
import 'package:design_system/theme/app_text_styles.dart';
import 'package:design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PointsCounter extends StatefulWidget {
  const PointsCounter({
    required this.points,
    this.controller,
    super.key,
  });

  final int points;
  final AnimationController? controller;

  @override
  State<PointsCounter> createState() => _PointsCounterState();
}

class _PointsCounterState extends State<PointsCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scaleAnimation;

  final duration = const Duration(milliseconds: 1500);

  @override
  void initState() {
    const scaleDuration = Duration(milliseconds: 200);
    controller = widget.controller ??
        AnimationController(
          vsync: this,
          duration: scaleDuration,
        );
    scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) => Container(
          padding: const EdgeInsets.only(left: 4, right: 10, top: 4, bottom: 4),
          transform: Matrix4.identity()..scale(scaleAnimation.value),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceBright,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DsAssets.images.estrella.image(),
              const SizedBox(width: 8),
              AnimatedCount(
                count: widget.points,
                duration: duration,
                curve: Curves.decelerate,
              ),
            ],
          ),
        ),
      );
}

class AnimatedCount extends ImplicitlyAnimatedWidget {
  final int count;

  const AnimatedCount({
    required this.count,
    required super.duration,
    super.key,
    super.curve,
  });

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween? _count;

  @override
  Widget build(BuildContext context) => Text(
        _count!.evaluate(animation).toString(),
        style: context.theme.textStyles.headlineSmall!.bold(),
      );

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _count = visitor(
      _count,
      widget.count,
      (dynamic value) => IntTween(begin: value as int),
    ) as IntTween?;
  }
}
