import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_scaffold.dart';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  context.localizations.admin_area,
                  style: context.theme.textStyles.displaySmall!.bold().copyWith(
                        color:
                            context.theme.customColors.textColor.getShade(500),
                      ),
                ),
                SizedBox(height: 24.h),
                isLogged
                    ? Column(
                        children: [
                          _CurrentUserInfo(currentUserEmail: currentUserEmail),
                          SizedBox(height: 12.h),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<AdminAreaCubit>().signOut(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(context.localizations.log_out),
                            ),
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
        builder: (context, state) => ElevatedButton(
          onPressed: state.isFormValid
              ? () => context.read<AdminAreaCubit>().signIn()
              : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(context.localizations.sign_in),
          ),
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
  Widget build(BuildContext context) => SizedBox(
        width: .4.sw,
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              enableSuggestions: false,
              onChanged: (email) =>
                  context.read<AdminAreaCubit>().changeEmail(email),
              decoration: InputDecoration(
                labelText: context.localizations.email,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _passwordController,
              enableSuggestions: false,
              onChanged: (password) =>
                  context.read<AdminAreaCubit>().changePassword(password),
              decoration: InputDecoration(
                labelText: context.localizations.password,
              ),
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
