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
          switch (type) {
            InformationSummaryType.points => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Assets.images.estrella.image(
                    height: 36,
                    width: 36,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '$value',
                    style:
                        context.theme.textStyles.headlineSmall!.bold().copyWith(
                              color: context.theme.customColors.textColor,
                            ),
                  ),
                ],
              ),
            InformationSummaryType.gestures => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.images.check.image(
                    height: 36,
                    width: 36,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$value',
                    style:
                        context.theme.textStyles.headlineSmall!.bold().copyWith(
                              color: context.theme.customColors.textColor,
                            ),
                  ),
                ],
              ),
            InformationSummaryType.time => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.images.reloj.image(
                    height: 36,
                    width: 36,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.high,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$minutes:'
                    '$seconds',
                    style:
                        context.theme.textStyles.headlineSmall!.bold().copyWith(
                              color: context.theme.customColors.textColor,
                            ),
                  ),
                ],
              )
          },
          if (showBorder)
            switch (type) {
              InformationSummaryType.points => Text(
                  context.localizations.points,
                  style: context.theme.textStyles.headlineSmall!
                      .semibold()
                      .copyWith(
                        color: context.theme.customColors.textColor,
                      ),
                ),
              InformationSummaryType.gestures => Text(
                  context.localizations.gestures,
                  style: context.theme.textStyles.headlineSmall!
                      .semibold()
                      .copyWith(
                        color: context.theme.customColors.textColor,
                      ),
                ),
              InformationSummaryType.time => Text(
                  context.localizations.time,
                  style: context.theme.textStyles.headlineSmall!
                      .semibold()
                      .copyWith(
                        color: context.theme.customColors.textColor,
                      ),
                ),
            },
        ],
      ),
    );
  }
}

enum InformationSummaryType {
  points,
  gestures,
  time,
}
