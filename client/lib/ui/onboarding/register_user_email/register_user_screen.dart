import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/onboarding/register_user_email/register_user_cubit.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

@RoutePage()
class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            RegisterUserCubit(context.read<GlobalEventHandlerCubit>()),
        child: _SignInContentScreen(),
      );
}

class _SignInContentScreen extends StatefulWidget {
  @override
  State<_SignInContentScreen> createState() => _SignInContentScreenState();
}

class _SignInContentScreenState extends State<_SignInContentScreen> {
  final _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) => AppScaffold(
        showBackButton: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.localizations.onboarding_email_title,
              style: context.theme.textStyles.displaySmall!.bold().copyWith(
                    color: context.theme.customColors.textColor.getShade(500),
                  ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: _SignInForm(
                emailTextController: _emailTextController,
                onChanged: (String text) =>
                    context.read<RegisterUserCubit>().changeEmail(text),
              ),
            ),
            Container(
              width: .4.sw,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                context.localizations.onboarding_email_description,
                style: context.theme.textStyles.bodyLarge!.copyWith(),
              ),
            ),
            _NextButtonSection(
              emailTextController: _emailTextController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: InkWell(
                onTap: context.read<RegisterUserCubit>().goToAdminAdrea,
                child: Text(
                  context.localizations.admin_area,
                  style: context.theme.textStyles.bodyLarge!.copyWith(
                    color: context.theme.customColors.textColor.getShade(500),
                  ),
                ),
              ),
            ),
          ]
              .animate(
                interval: 100.ms,
              )
              .fadeIn(
                duration: 400.ms,
                curve: Curves.easeIn,
              )
              .slideY(
                duration: 300.ms,
                begin: -.5,
                curve: Curves.easeOut,
              ),
        ),
      );
}

class _NextButtonSection extends StatelessWidget {
  final TextEditingController emailTextController;

  const _NextButtonSection({
    required this.emailTextController,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<RegisterUserCubit, RegisterUserBaseState>(
        builder: (context, state) => FilledButton(
          onPressed: state.isFormValid
              ? () {
                  context.read<RegisterUserCubit>().saveEmail();
                  emailTextController.clear();
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              : null,
          child: Text(
            context.localizations.continue_button,
            style: context.theme.textStyles.bodyLarge!.bold().copyWith(
                  color: context.theme.customColors.textColor.getShade(100),
                ),
          ),
        ),
      );
}

class _SignInForm extends StatelessWidget {
  final TextEditingController emailTextController;
  final Function(String) onChanged;

  const _SignInForm({
    required this.emailTextController,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: .4.sw,
        child: TextField(
          controller: emailTextController,
          enableSuggestions: false,
          onChanged: onChanged,
        ),
      );
}
