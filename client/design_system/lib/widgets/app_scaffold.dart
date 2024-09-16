import 'package:auto_route/auto_route.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/extensions/context_extensions.dart';
import 'package:design_system/theme/app_theme.dart';
import 'package:design_system/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final bool? showBackButton;
  final bool isScrollable;

  const AppScaffold({
    required this.child,
    this.isScrollable = false,
    this.showBackButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            const ScreenBackgroundContainer(),
            SafeArea(
              child: Container(
                width: 1.sw,
                height: 1.sh,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child:
                    isScrollable ? SingleChildScrollView(child: child) : child,
              ),
            ),
            if (showBackButton ?? context.router.canNavigateBack)
              Positioned(
                top: .07.sh,
                left: .07.sw,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: context.theme.customColors.textColor.getShade(500),
                  ),
                ),
              ),
          ],
        ),
      );
}
