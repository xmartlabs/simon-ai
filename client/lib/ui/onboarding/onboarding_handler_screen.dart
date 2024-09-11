import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/router/app_router.dart';

@RoutePage()
class OnboardingHandlerScreen extends StatelessWidget {
  const OnboardingHandlerScreen({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.localizations.onboarding_ready_to_play_title,
              style: context.theme.textStyles.displaySmall!.bold().copyWith(
                    color: context.theme.customColors.textColor.getShade(500),
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: .3.sw,
              child: FilledButton(
                onPressed: () =>
                    context.router.push(const TutorialExplanationRoute()),
                child: Text(
                  context.localizations.play,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
}
