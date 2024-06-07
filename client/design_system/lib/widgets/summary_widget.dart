import 'package:design_system/design_system.dart';
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
    required HandGestures gestures,
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
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surfaceBright,
          border: Border.all(
            color: context.theme.customColors.textColor!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            switch (type) {
              InformationSummaryType.points => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Estrella.png',
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
              InformationSummaryType.gestures => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/Check.png',
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
                    Image.asset(
                      'assets/images/Reloj.png',
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
              InformationSummaryType.points => Text(
                  'Puntaje',
                  style: context.theme.textStyles.headlineSmall!
                      .semibold()
                      .copyWith(
                        color: context.theme.customColors.textColor!,
                      ),
                ),
              InformationSummaryType.gestures => Text(
                  'Gestos',
                  style: context.theme.textStyles.headlineSmall!
                      .semibold()
                      .copyWith(
                        color: context.theme.customColors.textColor!,
                      ),
                ),
              InformationSummaryType.time => Text(
                  'Tiempo',
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

enum HandGestures {
  L,
  K,
  I,
  O,
}
