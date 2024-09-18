import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_button.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:design_system/widgets/app_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/onboarding/register_username/register_username_cubit.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

@RoutePage()
class RegisterUsernameScreen extends StatelessWidget {
  const RegisterUsernameScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            RegisterUsernameCubit(context.read<GlobalEventHandlerCubit>()),
        child: const _RegisterUsernameContent(),
      );
}

class _RegisterUsernameContent extends StatelessWidget {
  const _RegisterUsernameContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppScaffold(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.localizations.onboarding_username_title,
              style: context.theme.textStyles.displaySmall!.bold().copyWith(
                    color: context.theme.customColors.textColor.getShade(500),
                  ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: _SignInForm(),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                context.localizations.onboarding_username_description,
                style: context.theme.textStyles.bodyLarge!.copyWith(),
              ),
            ),
            AppButton(
              onPressed: () =>
                  context.read<RegisterUsernameCubit>().registerPlayer(),
              text: context.localizations.continue_button,
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

class _SignInForm extends StatefulWidget {
  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _usernameTextController = TextEditingController();
  late RegisterUsernameCubit _registerRegisterUsernameCubit;

  @override
  void dispose() {
    _usernameTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _registerRegisterUsernameCubit = context.read<RegisterUsernameCubit>();
    _usernameTextController.text =
        _registerRegisterUsernameCubit.state.username;
  }

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(maxWidth: 480),
        child: AppTextField(
          controller: _usernameTextController,
          keyboardType: TextInputType.name,
          onChange: (String text) =>
              _registerRegisterUsernameCubit.changeUsername(text),
        ),
      );
}
