import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simon_ai/ui/onboarding/register/register_player_section_cubit.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

@RoutePage(name: 'RegisterPlayerSectionRoute')
class RegisterPlayerSection extends StatelessWidget {
  const RegisterPlayerSection({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => RegisterPlayerSectionCubit(
          context.read<GlobalEventHandlerCubit>(),
        ),
        child: const AutoRouter(),
      );
}
