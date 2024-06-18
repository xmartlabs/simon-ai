import 'package:design_system/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) => Container(
        color: context.theme.colorScheme.surface,
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/images/background_green_prop.png',
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/background_red_prop.png',
              ),
            ),
          ],
        ),
      );
}
