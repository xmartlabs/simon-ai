import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformationSummary extends StatelessWidget {
  const InformationSummary({
    required this.type,
    this.value = 0,
    this.time = Duration.zero,
    this.showBorder = false,
    this.height,
    this.width,
    super.key,
  });

  final InformationSummaryType type;
  final int value;
  final bool showBorder;
  final Duration time;
  final double? height;
  final double? width;

  factory InformationSummary.points({
    required int value,
    bool showBorder = false,
    double? height,
    double? width,
  }) =>
      InformationSummary(
        type: InformationSummaryType.points,
        value: value,
        showBorder: showBorder,
        height: height,
        width: width,
      );
  factory InformationSummary.gestures({
    required int value,
    bool showBorder = false,
    double? height,
    double? width,
  }) =>
      InformationSummary(
        type: InformationSummaryType.gestures,
        value: value,
        showBorder: showBorder,
        height: height,
        width: width,
      );

  factory InformationSummary.time({
    required Duration time,
    bool showBorder = false,
    double? height,
    double? width,
  }) =>
      InformationSummary(
        type: InformationSummaryType.time,
        showBorder: showBorder,
        time: time,
        height: height,
        width: width,
      );

  @override
  Widget build(BuildContext context) {
    final minutes = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = time.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.all(12),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: context.theme.customColors.lightSurfaceColor.getShade(300),
        border: showBorder
            ? Border.all(
                color: context.theme.colorScheme.surface.getShade(500),
                width: 2,
              )
            : null,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Icon(type: type, value: value, minutes: minutes, seconds: seconds),
          if (showBorder) _Subtitle(type: type),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    required this.type,
    required this.value,
    required this.minutes,
    required this.seconds,
    super.key,
  });

  final InformationSummaryType type;
  final int value;
  final String minutes;
  final String seconds;

  @override
  Widget build(BuildContext context) => SizedBox(
        child: switch (type) {
          InformationSummaryType.points => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.images.estrella.image(
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(width: 8),
                Text(
                  '$value',
                  style:
                      context.theme.textStyles.headlineLarge!.bold().copyWith(
                            color: context.theme.customColors.textColor,
                          ),
                ),
              ],
            ),
          InformationSummaryType.gestures => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.images.check.image(
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(width: 8),
                Text(
                  '$value',
                  style:
                      context.theme.textStyles.headlineLarge!.bold().copyWith(
                            color: context.theme.customColors.textColor,
                          ),
                ),
              ],
            ),
          InformationSummaryType.time => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.images.reloj.image(
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(width: 8),
                Text(
                  '$minutes:'
                  '$seconds',
                  style:
                      context.theme.textStyles.headlineLarge!.bold().copyWith(
                            color: context.theme.customColors.textColor,
                          ),
                ),
              ],
            )
        },
      );
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({
    required this.type,
    super.key,
  });

  final InformationSummaryType type;

  @override
  Widget build(BuildContext context) => Container(
        child: switch (type) {
          InformationSummaryType.points => Text(
              context.localizations.points,
              style:
                  context.theme.textStyles.headlineSmall!.semibold().copyWith(
                        color: context.theme.customColors.textColor,
                      ),
            ),
          InformationSummaryType.gestures => Text(
              context.localizations.gestures,
              style:
                  context.theme.textStyles.headlineSmall!.semibold().copyWith(
                        color: context.theme.customColors.textColor,
                      ),
            ),
          InformationSummaryType.time => Text(
              context.localizations.time,
              style:
                  context.theme.textStyles.headlineSmall!.semibold().copyWith(
                        color: context.theme.customColors.textColor,
                      ),
            ),
        },
      );
}

enum InformationSummaryType {
  points,
  gestures,
  time,
}
