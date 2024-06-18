import 'package:design_system/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            const Background(),
            SafeArea(
              child: Container(
                width: 1.sw,
                height: 1.sh,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: child,
              ),
            ),
          ],
        ),
      );
}
