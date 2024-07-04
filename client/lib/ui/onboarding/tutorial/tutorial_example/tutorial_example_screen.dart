import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/game_screen/game_state_screens/finish_tutorial_game_screen.dart';
import 'package:simon_ai/ui/onboarding/tutorial/tutorial_example/tutorial_example_cubit.dart';

@RoutePage()
class TutorialExampleScreen extends StatelessWidget {
  const TutorialExampleScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => TutorialExampleCubit(),
        child: const FinishGameTutorialScreen(),
      );
}
