import 'package:auto_route/auto_route.dart';
import 'package:design_system/extensions/context_extensions.dart';
import 'package:design_system/widgets/points_counter.dart';
import 'package:design_system/widgets/summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/ui/onboarding/register_user/register_user_cubit.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

@RoutePage()
class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) =>
            RegisterUserCubit(context.read<GlobalEventHandlerCubit>()),
        child: _SignInContentScreen(),
      );
}

class _SignInContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<RegisterUserCubit, RegisterUserBaseState>(
        builder: (context, state) => Scaffold(
          backgroundColor: context.theme.colorScheme.secondary,
          appBar: AppBar(
            title: Text(context.localizations.sign_in),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: _SignInForm()),
              if (context.read<RegisterUserCubit>().state.error.isNotEmpty)
                Text(
                  context.localizations
                      .error(context.read<RegisterUserCubit>().state.error),
                ),
              const PointsCounter(
                points: 100,
              ),
              const SizedBox(height: 10),
              InformationSummary.time(time: const Duration(seconds: 320)),
              const SizedBox(height: 10),
              SizedBox(
                width: .4.sw,
                child: FilledButton(
                  onPressed: () => Logger.i('Continue button pressed'),
                  child: Text(
                    context.localizations.continue_button,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: TextButton(
                  onPressed: () => context.read<RegisterUserCubit>().signIn(),
                  child: Text(context.localizations.sign_in),
                ),
              ),
            ],
          ),
        ),
      );
}

class _SignInForm extends StatefulWidget {
  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _emailTextController = TextEditingController();
  final _nicknameTextController = TextEditingController();
  late RegisterUserCubit _registerRegisterUserCubit;

  @override
  void dispose() {
    _emailTextController.dispose();
    _nicknameTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _registerRegisterUserCubit = context.read<RegisterUserCubit>();
    // TODO: This should be bound
    _emailTextController.text = _registerRegisterUserCubit.state.email ?? '';
    _nicknameTextController.text =
        _registerRegisterUserCubit.state.nickname ?? '';
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _emailTextController,
              onChanged: (String text) =>
                  _registerRegisterUserCubit.changeEmail(text),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: context.localizations.mail,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              controller: _nicknameTextController,
              onChanged: (String nickname) =>
                  _registerRegisterUserCubit.changeNickname(nickname),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: context.localizations.password,
              ),
            ),
          ),
        ],
      );
}
