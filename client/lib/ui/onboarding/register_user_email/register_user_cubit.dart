import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/core/repository/user_repository.dart';
import 'package:simon_ai/ui/router/app_router.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

part 'register_user_cubit.freezed.dart';
part 'register_user_state.dart';

class RegisterUserCubit extends Cubit<RegisterUserBaseState> {
  final GlobalEventHandler _globalEventHandler;
  final SessionRepository _sessionRepository = DiProvider.get();
  final UserRepository _userRepository = DiProvider.get();
  final AppRouter _appRouter = DiProvider.get();

  RegisterUserCubit(this._globalEventHandler)
      : super(
          const RegisterUserBaseState.state(
            email: 'hi@xmartlabs.com',
            nickname: 'xmartlabs',
            error: '',
          ),
        );

  void changeEmail(String email) => emit(state.copyWith(email: email));

  void changeNickname(String nickname) =>
      emit(state.copyWith(nickname: nickname));

  Future<void> saveEmail() async {
    final response = await _sessionRepository.saveEmail(state.email!);
    if (response.isFailure) {
      _globalEventHandler.handleError(response.error);
    }
    if (response.isSuccess) {
      await _userRepository.insertUser(User(email: state.email!));
      unawaited(_appRouter.push(const RegisterUsernameRoute()));
    }
  }
}
