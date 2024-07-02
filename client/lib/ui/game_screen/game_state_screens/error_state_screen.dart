import 'package:design_system/design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/game_screen/game_screen_cubit.dart';

class ErrorStateScreen extends StatelessWidget {
  const ErrorStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? errorMessage = context.select(
      (GameScreenCubit cubit) => cubit.state.error,
    );
    return Text(
      errorMessage ?? 'An error occurred',
      style: context.theme.textStyles.displayMedium!
          .copyWith(color: context.theme.customColors.textColor),
    );
  }
}
