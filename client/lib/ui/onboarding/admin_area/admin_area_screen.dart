import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_button.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:design_system/widgets/app_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/onboarding/admin_area/admin_area_cubit.dart';

@RoutePage()
class AdminAreaScreen extends StatelessWidget {
  const AdminAreaScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => AdminAreaCubit(),
        child: _AdminAreaContentScreen(),
      );
}

class _AdminAreaContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocSelector<AdminAreaCubit, AdminAreaState, String?>(
        selector: (state) => state.currentUserEmail,
        builder: (context, currentUserEmail) {
          final isLogged = currentUserEmail != null;
          return AppScaffold(
            resizeToAvoidBottomInset: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  context.localizations.admin_area,
                  textAlign: TextAlign.center,
                  style: context.theme.textStyles.displaySmall!.bold().copyWith(
                        color:
                            context.theme.customColors.textColor.getShade(500),
                      ),
                ),
                SizedBox(height: 12.h),
                isLogged
                    ? Column(
                        children: [
                          _CurrentUserInfo(currentUserEmail: currentUserEmail),
                          SizedBox(height: 12.h),
                          AppButton(
                            text: context.localizations.log_out,
                            onPressed: () =>
                                context.read<AdminAreaCubit>().signOut(),
                          ),
                        ],
                      )
                    : const _NotLoggedSection(),
              ],
            ),
          );
        },
      );
}

class _NotLoggedSection extends StatelessWidget {
  const _NotLoggedSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: const _AdminAreaForm(),
          ),
          const _BottomButton(),
        ],
      );
}

class _CurrentUserInfo extends StatelessWidget {
  final String currentUserEmail;

  const _CurrentUserInfo({
    required this.currentUserEmail,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Text(
        context.localizations.admin_area_logged_description(currentUserEmail),
        style: context.theme.textStyles.bodyLarge!.copyWith(
          color: context.theme.customColors.textColor.getShade(500),
        ),
      );
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminAreaCubit, AdminAreaState>(
        builder: (context, state) => AppButton(
          onPressed: state.isFormValid
              ? () => context.read<AdminAreaCubit>().signIn()
              : null,
          text: context.localizations.sign_in,
        ),
      );
}

class _AdminAreaForm extends StatefulWidget {
  const _AdminAreaForm({
    super.key,
  });

  @override
  State<_AdminAreaForm> createState() => _AdminAreaFormState();
}

class _AdminAreaFormState extends State<_AdminAreaForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          children: [
            AppTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              onChange: (email) =>
                  context.read<AdminAreaCubit>().changeEmail(email),
              labelText: context.localizations.email,
            ),
            SizedBox(height: 12.h),
            AppTextField(
              controller: _passwordController,
              enableSuggestions: false,
              onChange: (password) =>
                  context.read<AdminAreaCubit>().changePassword(password),
              labelText: context.localizations.password,
              obscureText: true,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _ErrorSection(),
              ],
            ),
          ],
        ),
      );
}

class _ErrorSection extends StatelessWidget {
  const _ErrorSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      BlocSelector<AdminAreaCubit, AdminAreaState, String?>(
        selector: (state) => state.error,
        builder: (context, error) => (error != null)
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  error,
                  style:
                      context.theme.textStyles.bodyMedium!.semibold().copyWith(
                            color: context.theme.colorScheme.error,
                          ),
                ),
              )
            : Container(),
      );
}
