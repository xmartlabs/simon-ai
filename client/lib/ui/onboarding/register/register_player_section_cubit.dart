import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/common/extension/string_extensions.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/player.dart';
import 'package:simon_ai/core/repository/player_repository.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/ui/router/app_router.dart';
import 'package:simon_ai/ui/section/error_handler/global_event_handler_cubit.dart';

part 'register_player_section_cubit.freezed.dart';
part 'register_player_section_state.dart';

class RegisterPlayerSectionCubit extends Cubit<RegisterPlayerSectionState>
    implements RegisterPlayerHandler {
  final GlobalEventHandler _globalEventHandler;
  final AppRouter _appRouter = DiProvider.get();
  final PlayerRepository _playerRepository = DiProvider.get();
  final SessionRepository _sessionRepository = DiProvider.get();

  String? email;

  RegisterPlayerSectionCubit(this._globalEventHandler)
      : super(const RegisterPlayerSectionState.initial());

  @override
  Future<void> setEmail(String email) {
    this.email = email;
    return _appRouter.push(const RegisterPlayerNameRoute());
  }

  @override
  Future<void> setName(String name) async {
    final result =
        await _playerRepository.setPlayer(Player(email: email!, name: name));

    if (result.isSuccess) {
      await _appRouter.topMostRouter().navigate(const OnboardingHandlerRoute());
    } else {
      _globalEventHandler.handleError(result.error);
    }
  }

  @override
  Future<String?> getSuggestedEmail() =>
      _sessionRepository.currentUserEmail.first.then(
        (value) => value.isNotNullOrBlank
            ? null
            : _playerRepository
                .getCurrentPlayer()
                .first
                .then((value) => value?.email),
      );

  @override
  Future<String?> getSuggestedName() async =>
      (email == null
          ? null
          : (await _playerRepository.getPlayer(email!))?.name) ??
      email?.removePatternSuffix(RegExp('@.*'));
}

abstract interface class RegisterPlayerHandler {
  Future<void> setEmail(String email);

  Future<void> setName(String name);

  Future<String?> getSuggestedEmail();

  Future<String?> getSuggestedName();
}
