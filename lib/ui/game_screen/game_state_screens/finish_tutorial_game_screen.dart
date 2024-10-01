import 'package:design_system/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/extensions/context_extensions.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

class FinishGameTutorialScreen extends StatelessWidget {
  const FinishGameTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.localizations.congratulations),
              Text(context.localizations.completed_game_with),
              AppButton(
                onPressed: context.read<GameScreenCubit>().startGame,
                text: context.localizations.back_to_the_game,
              ),
            ],
          ),
        ),
      );
}
