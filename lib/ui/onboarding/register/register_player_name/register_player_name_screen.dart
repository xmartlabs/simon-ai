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
import 'package:simon_ai/ui/onboarding/register/register_player_name/register_player_name_cubit.dart';

@RoutePage()
class RegisterPlayerNameScreen extends StatelessWidget {
  const RegisterPlayerNameScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => RegisterPlayerNameCubit(
          context.read<RegisterPlayerSectionCubit>(),
        ),
        child: const _RegisterPlayerNameContent(),
      );
}

class _RegisterPlayerNameContent extends StatelessWidget {
  const _RegisterPlayerNameContent({
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
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: AppConstrainedWidget(
                child: Text(
                  textAlign: TextAlign.center,
                  context.localizations.onboarding_username_description,
                  style: context.theme.textStyles.bodyLarge!.copyWith(),
                ),
              ),
            ),
            AppButton(
              onPressed: () =>
                  context.read<RegisterPlayerNameCubit>().registerPlayer(),
              text: context.localizations.continue_button,
            ),
          ].fadeInAnimation,
        ),
      );
}

class _SignInForm extends StatefulWidget {
  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _usernameTextController = TextEditingController();
  late RegisterPlayerNameCubit _registerRegisterUsernameCubit;

  @override
  void dispose() {
    _usernameTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _registerRegisterUsernameCubit = context.read<RegisterPlayerNameCubit>();
    _usernameTextController.text =
        _registerRegisterUsernameCubit.state.username;
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<RegisterPlayerNameCubit, RegisterPlayerNameState>(
        listener: (context, state) {
          if (state.username != _usernameTextController.text) {
            _usernameTextController.text = state.username;
          }
        },
        child: AppConstrainedWidget(
          child: AppTextField(
            controller: _usernameTextController,
            keyboardType: TextInputType.name,
            onChange: (String text) =>
                _registerRegisterUsernameCubit.changeUsername(text),
          ),
        ),
      );
}
