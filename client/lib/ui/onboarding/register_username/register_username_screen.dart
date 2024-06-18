import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/onboarding/register_username/register_username_cubit.dart';

@RoutePage()
class RegisterUsernameScreen extends StatelessWidget {
  const RegisterUsernameScreen({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.localizations.onboarding_username_title,
              style: context.theme.textStyles.displaySmall!.bold().copyWith(
                    color: context.theme.customColors.textColor!.getShade(500),
                  ),
            ),
            SizedBox(height: 24.h),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 16.h),
            //   child: _SignInForm(),
            // ),
            Container(
              width: .4.sw,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                context.localizations.onboarding_username_description,
                style: context.theme.textStyles.bodyLarge!.copyWith(),
              ),
            ),
            FilledButton(
              onPressed: context.read<RegisterUsernameCubit>().close,
              child: Text(
                context.localizations.continue_button,
                style: context.theme.textStyles.bodyLarge!.bold().copyWith(
                      color:
                          context.theme.customColors.textColor!.getShade(100),
                    ),
              ),
            ),
          ],
        ),
      );
}
