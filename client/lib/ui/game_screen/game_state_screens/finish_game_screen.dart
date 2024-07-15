import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

class FinishGameScreen extends StatelessWidget {
  const FinishGameScreen({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.localizations.congratulations,
            style: context.theme.textStyles.displayLarge!.copyWith(
              color: context.theme.customColors.textColor.getShade(500),
            ),
          ),
          SizedBox(height: 25.h),
          Text(
            context.localizations.completed_game_with,
            style: context.theme.textStyles.bodyLarge!.copyWith(
              color: context.theme.customColors.textColor.getShade(500),
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _Gestures(),
              SizedBox(width: 20.w),
              const _Points(),
              SizedBox(width: 20.w),
              const _Time(),
            ],
          ),
        ],
      );
}

class _Time extends StatelessWidget {
  const _Time({
    super.key,
  });

  @override
  Widget build(BuildContext context) => InformationSummary.time(
        time: context.read<GameScreenCubit>().gameDuration,
        width: .11.sw,
        showBorder: true,
      );
}

class _Points extends StatelessWidget {
  const _Points({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final int points = context.select(
      (GameScreenCubit cubit) => cubit.state.currentPoints,
    );
    return InformationSummary.points(
      value: points,
      width: .11.sw,
      showBorder: true,
    );
  }
}

class _Gestures extends StatelessWidget {
  const _Gestures({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final int gestures = context.select(
      (GameScreenCubit cubit) => cubit.state.currentSequence!.length,
    );
    return InformationSummary.gestures(
      value: gestures,
      width: .11.sw,
      showBorder: true,
    );
  }
}
