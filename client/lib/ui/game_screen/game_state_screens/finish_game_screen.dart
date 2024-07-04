import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              InformationSummary.gestures(
                value: 12,
                width: .11.sw,
                showBorder: true,
              ),
              SizedBox(width: 20.w),
              InformationSummary.points(
                value: 120,
                width: .11.sw,
                showBorder: true,
              ),
              SizedBox(width: 20.w),
              InformationSummary.time(
                time: const Duration(minutes: 3),
                width: .11.sw,
                showBorder: true,
              ),
            ],
          ),
        ],
      );
}
