import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/common/extension/stream_future_extensions.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

part 'register_username_cubit.freezed.dart';
part 'register_username_state.dart';

class RegisterUsernameCubit extends Cubit<RegisterUsernameState> {
  final GlobalEventHandler _globalEventHandler;
  final SessionRepository _sessionRepository = DiProvider.get();
  RegisterUsernameCubit(this._globalEventHandler)
      : super(
          const RegisterUsernameState.initial(username: ''),
        );

  void changeUsername(String username) => emit(
        state.copyWith(username: username),
      );

  Future<void> signIn() => _sessionRepository
      .saveUsername(state.username)
      .filterSuccess(_globalEventHandler.handleError);
}
