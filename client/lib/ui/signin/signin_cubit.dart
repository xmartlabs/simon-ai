import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/common/extension/stream_future_extensions.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

part 'signin_cubit.freezed.dart';
part 'signin_state.dart';

class SignInCubit extends Cubit<SignInBaseState> {
  final GlobalEventHandler _globalEventHandler;
  final SessionRepository _sessionRepository = DiProvider.get();

  SignInCubit(this._globalEventHandler)
      : super(
          const SignInBaseState.state(
            email: 'hi@xmartlabs.com',
            password: 'xmartlabs',
            error: '',
          ),
        );

  void changeEmail(String email) => emit(state.copyWith(email: email));

  void changePassword(String password) =>
      emit(state.copyWith(password: password));

  Future<void> signIn() => _sessionRepository
      .signInUser(email: state.email!, password: state.password!)
      .filterSuccess(_globalEventHandler.handleError);
}
