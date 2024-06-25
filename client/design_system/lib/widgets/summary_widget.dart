import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InformationSummary extends StatelessWidget {
  const InformationSummary({
    required this.type,
    this.value = 0,
    this.time = Duration.zero,
    super.key,
  });

  final InformationSummaryType type;
  final int value;
  final Duration time;

  factory InformationSummary.points({
    required int value,
  }) =>
      InformationSummary(
        type: InformationSummaryType.points,
        value: value,
      );
  factory InformationSummary.gestures({
    required int value,
  }) =>
      const InformationSummary(
        type: InformationSummaryType.gestures,
      );

  factory InformationSummary.time({
    required Duration time,
  }) =>
      InformationSummary(
        type: InformationSummaryType.time,
        time: time,
      );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: context.theme.customColors.lightSurfaceColor!.getShade(300),
          shape: const StadiumBorder(),
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
                      style: context.theme.textStyles.headlineSmall!
                          .bold()
                          .copyWith(
                            color: context.theme.customColors.textColor!,
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
                      style: context.theme.textStyles.headlineSmall!
                          .bold()
                          .copyWith(
                            color: context.theme.customColors.textColor!,
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
                      '${time.inMinutes.remainder(60)}:'
                      '${time.inSeconds.remainder(60)}',
                      style: context.theme.textStyles.headlineSmall!
                          .bold()
                          .copyWith(
                            color: context.theme.customColors.textColor!,
                          ),
                    ),
                  ],
                )
            },
            switch (type) {
              InformationSummaryType.points => Container(),
              InformationSummaryType.gestures => Text(
                  context.localizations.gestures,
                  style: context.theme.textStyles.headlineSmall!
                      .semibold()
                      .copyWith(
                        color: context.theme.customColors.textColor!,
                      ),
                ),
              InformationSummaryType.time => Text(
                  context.localizations.time,
                  style: context.theme.textStyles.headlineSmall!
                      .semibold()
                      .copyWith(
                        color: context.theme.customColors.textColor!,
                      ),
                ),
            },
          ],
        ),
      );
}

enum InformationSummaryType {
  points,
  gestures,
  time,
}
