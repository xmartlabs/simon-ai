//ignore_for_file: unused-files, unused-code
import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_button.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/common/app_constrained_widget.dart';
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
  Widget build(BuildContext context) =>
      BlocBuilder<TutorialExplanationCubit, TutorialExplanationState>(
        builder: (context, state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.localizations.tutorial_next_steps_title,
              style: context.theme.textStyles.displaySmall!.bold().copyWith(
                    color: context.theme.customColors.textColor.getShade(500),
                  ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: AppConstrainedWidget(
                child: Text(
                  context.localizations.tutorial_next_steps_description,
                  style: context.theme.textStyles.bodyLarge!.copyWith(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              child: AppButton(
                onPressed: state.hasCameraPermission != null
                    ? () {
                        final cubit = context.read<TutorialExplanationCubit>();
                        _handleCameraPermission(
                          hasCameraPermission: state.hasCameraPermission!,
                          onPressed: onPressed,
                          navigateToGame: cubit.navigateToGame,
                        );
                      }
                    : null,
                text: context.localizations.continue_button,
              ),
            ),
          ],
        ),
      );

  void _handleCameraPermission({
    required bool hasCameraPermission,
    required VoidCallback onPressed,
    required VoidCallback navigateToGame,
  }) =>
      hasCameraPermission ? navigateToGame() : onPressed();
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
                  color: context.theme.customColors.textColor.getShade(500),
                ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: AppConstrainedWidget(
              child: Text(
                context.localizations.tutorial_what_hand_description,
                style: context.theme.textStyles.bodyLarge!.copyWith(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          AppConstrainedWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: onPressed,
                    text: context.localizations.left,
                  ),
                ),
                SizedBox(width: .1.sw),
                Expanded(
                  child: AppButton(
                    onPressed: onPressed,
                    text: context.localizations.right,
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
                  color: context.theme.customColors.textColor.getShade(500),
                ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: AppConstrainedWidget(
              child: Text(
                context.localizations.tutorial_camera_permissions_description,
                style: context.theme.textStyles.bodyLarge!.copyWith(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          AppButton(
            onPressed: () {
              context
                  .read<TutorialExplanationCubit>()
                  .requestCameraPermission();
            },
            text: context.localizations.activate_camera,
          ),
        ],
      );
}
