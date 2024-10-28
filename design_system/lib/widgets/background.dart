import 'package:design_system/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:design_system/gen/assets.gen.dart';

class ScreenBackgroundContainer extends StatelessWidget {
  final bool showSpiderLottie;

  const ScreenBackgroundContainer({super.key, this.showSpiderLottie = false});

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
              child: Assets.images.backgroundGreenProp.image(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Assets.images.backgroundRedProp.image(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Assets.images.backgroundDownSpiderweb.image(),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Assets.images.backgroundTopSpiderweb.image(),
            ),
            if (showSpiderLottie)
              Positioned(
                top: 0,
                right: 0,
                child: Assets.lottie.spider.lottie(),
              ),
          ],
        ),
      );
}
