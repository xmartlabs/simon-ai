import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/ui/router/app_router.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

part 'register_username_cubit.freezed.dart';
part 'register_username_state.dart';

class RegisterUsernameCubit extends Cubit<RegisterUsernameState> {
  final GlobalEventHandler _globalEventHandler;
  final SessionRepository _sessionRepository = DiProvider.get();
  final AppRouter _appRouter = DiProvider.get();
  RegisterUsernameCubit(this._globalEventHandler)
      : super(
          const RegisterUsernameState.initial(username: ''),
        );

  void changeUsername(String username) => emit(
        state.copyWith(username: username),
      );

  Future<void> signInUser() async {
    final user = await _sessionRepository.getUser();
    final res = await _sessionRepository.signInUser(
      email: user!.email,
      username: state.username,
    );

    if (res.isFailure) _globalEventHandler.handleError(res.error);
    if (res.isSuccess) {
      unawaited(_appRouter.push(const OnboardingHandlerRoute()));
    }
  }
}
