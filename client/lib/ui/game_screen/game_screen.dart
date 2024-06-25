import 'package:auto_route/auto_route.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/ui/common/dashed_stadium_border.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

@RoutePage()
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => GameScreenCubit(),
        child: const _GameScreenContent(),
      );
}

class _GameScreenContent extends StatelessWidget {
  const _GameScreenContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: 1.sw,
              height: 1.sh,
            ),
            Align(
              child: Opacity(
                opacity: .5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: context.theme.colorScheme.surface.getShade(400),
                  ),
                  width: .8.sw,
                  height: .8.sh,
                  child: Container(
                    margin: const EdgeInsets.all(42),
                    decoration: ShapeDecoration(
                      shape: DashedStadiumBorder(
                        inset: true,
                        side: BorderSide(
                          color: context.theme.colorScheme.surfaceBright,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
