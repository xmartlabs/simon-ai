import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/onboarding/tutorial/tutorial_explanation/tutorial_explanation_cubit.dart';

@RoutePage()
class TutorialExplanationScreen extends StatefulWidget {
  const TutorialExplanationScreen({super.key});

  @override
  State<TutorialExplanationScreen> createState() =>
      _TutorialExplanationScreenState();
}

class _TutorialExplanationScreenState extends State<TutorialExplanationScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => TutorialExplanationCubit(),
        child: AppScaffold(
          child: PageView.builder(
            controller: _pageController,
            itemCount: OnboardingSteps.values.length,
            itemBuilder: (context, index) => _PageviewContent(
              step: OnboardingSteps.values[index],
              onPressed: () => _pageController.nextPage(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        ),
      );
}

class _PageviewContent extends StatelessWidget {
  const _PageviewContent({
    required this.step,
    required this.onPressed,
    super.key,
  });

  final OnboardingSteps step;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => switch (step) {
        OnboardingSteps.initial =>
          _InitialExplanationStep(onPressed: onPressed),
        OnboardingSteps.hands => _HandsExplanationStep(onPressed: onPressed),
        OnboardingSteps.permissions =>
          _PermissionsExplanationStep(onPressed: onPressed),
      };
}

class _InitialExplanationStep extends StatelessWidget {
  const _InitialExplanationStep({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.localizations.tutorial_next_steps_title,
            style: context.theme.textStyles.displaySmall!.bold().copyWith(
                  color: context.theme.customColors.textColor!.getShade(500),
                ),
          ),
          SizedBox(height: 24.h),
          Container(
            width: .4.sw,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              context.localizations.tutorial_next_steps_description,
              style: context.theme.textStyles.bodyLarge!.copyWith(),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: .28.sw,
            child: FilledButton(
              onPressed: onPressed,
              child: Text(
                context.localizations.continue_button,
                style: context.theme.textStyles.bodyLarge!.bold().copyWith(
                      color:
                          context.theme.customColors.textColor!.getShade(100),
                    ),
              ),
            ),
          ),
        ],
      );
}

class _HandsExplanationStep extends StatelessWidget {
  const _HandsExplanationStep({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.localizations.tutorial_what_hand_title,
            style: context.theme.textStyles.displaySmall!.bold().copyWith(
                  color: context.theme.customColors.textColor!.getShade(500),
                ),
          ),
          SizedBox(height: 24.h),
          Container(
            width: .4.sw,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              context.localizations.tutorial_what_hand_description,
              style: context.theme.textStyles.bodyLarge!.copyWith(),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: .4.sw,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onPressed,
                    child: Text(
                      context.localizations.left,
                      style:
                          context.theme.textStyles.bodyLarge!.bold().copyWith(
                                color: context.theme.customColors.textColor!
                                    .getShade(100),
                              ),
                    ),
                  ),
                ),
                SizedBox(width: .1.sw),
                Expanded(
                  child: FilledButton(
                    onPressed: onPressed,
                    child: Text(
                      context.localizations.right,
                      style:
                          context.theme.textStyles.bodyLarge!.bold().copyWith(
                                color: context.theme.customColors.textColor!
                                    .getShade(100),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _PermissionsExplanationStep extends StatelessWidget {
  const _PermissionsExplanationStep({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.localizations.tutorial_camera_permissions_title,
            style: context.theme.textStyles.displaySmall!.bold().copyWith(
                  color: context.theme.customColors.textColor!.getShade(500),
                ),
          ),
          SizedBox(height: 24.h),
          Container(
            width: .4.sw,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              context.localizations.tutorial_camera_permissions_description,
              style: context.theme.textStyles.bodyLarge!.copyWith(),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),
          FilledButton(
            onPressed: onPressed,
            child: Text(
              context.localizations.activate_camera,
              style: context.theme.textStyles.bodyLarge!.bold().copyWith(
                    color: context.theme.customColors.textColor!.getShade(100),
                  ),
            ),
          ),
        ],
      );
}
