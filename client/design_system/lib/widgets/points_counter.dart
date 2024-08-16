import 'package:design_system/extensions/context_extensions.dart';
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

  @override
  void initState() {
    controller = widget.controller ??
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
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
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) => Container(
          transform: Matrix4.identity()..scale(scaleAnimation.value),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceBright,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/Estrella.png'),
              const SizedBox(width: 8),
              AnimatedCount(
                count: widget.points,
                duration: const Duration(milliseconds: 1500),
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
        style: context.theme.textStyles.bodyLarge!.bold(),
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
