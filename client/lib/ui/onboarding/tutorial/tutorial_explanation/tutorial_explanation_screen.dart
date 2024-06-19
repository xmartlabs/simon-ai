import 'package:auto_route/auto_route.dart';
import 'package:design_system/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/onboarding/tutorial/tutorial_explanation/tutorial_explanation_cubit.dart';

@RoutePage()
class TutorialExplanationScreen extends StatelessWidget {
  const TutorialExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => TutorialExplanationCubit(),
        child: const AppScaffold(
          child: Column(),
        ),
      );
}
