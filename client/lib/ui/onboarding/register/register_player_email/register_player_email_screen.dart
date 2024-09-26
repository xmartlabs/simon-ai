import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_button.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:design_system/widgets/app_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/common/app_constrained_widget.dart';
import 'package:simon_ai/ui/extensions/widget_list_extensions.dart';
import 'package:simon_ai/ui/onboarding/register/register_player_section_cubit.dart';
import 'package:simon_ai/ui/onboarding/register/register_player_email/register_player_email_cubit.dart';

@RoutePage()
class RegisterPlayerEmailScreen extends StatelessWidget {
  const RegisterPlayerEmailScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => RegisterPlayerEmailCubit(
          context.read<RegisterPlayerSectionCubit>(),
        ),
        child: _SignInContentScreen(),
      );
}

class _SignInContentScreen extends StatefulWidget {
  @override
  State<_SignInContentScreen> createState() => _SignInContentScreenState();
}

class _SignInContentScreenState extends State<_SignInContentScreen> {
  late TextEditingController _emailTextController;

  @override
  void initState() {
    _emailTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<RegisterPlayerEmailCubit, RegisterPlayerEmailBaseState>(
        listener: (context, state) {
          if (state.email != _emailTextController.text) {
            _emailTextController.text = state.email ?? '';
          }
        },
        child: AppScaffold(
          showBackButton: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                context.localizations.onboarding_email_title,
                style: context.theme.textStyles.displaySmall!.bold().copyWith(
                      color: context.theme.customColors.textColor.getShade(500),
                    ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
                child: _SignInForm(
                  emailTextController: _emailTextController,
                  onChanged: (String text) => context
                      .read<RegisterPlayerEmailCubit>()
                      .changeEmail(text),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: AppConstrainedWidget(
                  child: Text(
                    textAlign: TextAlign.center,
                    context.localizations.onboarding_email_description,
                    style: context.theme.textStyles.bodyLarge!.copyWith(),
                  ),
                ),
              ),
              _NextButtonSection(
                emailTextController: _emailTextController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: InkWell(
                  onTap:
                      context.read<RegisterPlayerEmailCubit>().goToAdminAdrea,
                  child: Text(
                    context.localizations.admin_area,
                    style: context.theme.textStyles.bodyLarge!.copyWith(
                      color: context.theme.customColors.textColor.getShade(500),
                    ),
                  ),
                ),
              ),
            ].fadeInAnimation,
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
      BlocBuilder<RegisterPlayerEmailCubit, RegisterPlayerEmailBaseState>(
        builder: (context, state) => AppButton(
          onPressed: state.isFormValid
              ? () {
                  context.read<RegisterPlayerEmailCubit>().saveEmail();
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              : null,
          text: context.localizations.continue_button,
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
  Widget build(BuildContext context) => AppConstrainedWidget(
        child: AppTextField(
          controller: emailTextController,
          keyboardType: TextInputType.emailAddress,
          enableSuggestions: false,
          onChange: onChanged,
        ),
      );
}
