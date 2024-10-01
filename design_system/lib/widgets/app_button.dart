import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/extensions/context_extensions.dart';
import 'package:design_system/theme/app_text_styles.dart';
import 'package:design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(
          minWidth: 300,
        ),
        child: FilledButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: context.theme.textStyles.bodyLarge!.bold().copyWith(
                  color: context.theme.customColors.textColor.getShade(100),
                ),
          ),
        ),
      );
}
