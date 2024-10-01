import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/common/extension/string_extensions.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/ui/onboarding/register/register_player_section_cubit.dart';
import 'package:simon_ai/ui/router/app_router.dart';

part 'register_player_email_cubit.freezed.dart';
part 'register_player_email_state.dart';

class RegisterPlayerEmailCubit extends Cubit<RegisterPlayerEmailBaseState> {
  final AppRouter _appRouter = DiProvider.get();
  final RegisterPlayerHandler _registerPlayerHandler;

  RegisterPlayerEmailCubit(this._registerPlayerHandler)
      : super(
          const RegisterPlayerEmailBaseState.state(
            email: '',
          ),
        ) {
    _registerPlayerHandler.getSuggestedEmail().then((email) {
      if (email != null) {
        changeEmail(email);
      }
    });
  }

  void changeEmail(String email) => emit(state.copyWith(email: email));

  Future<void> saveEmail() => _registerPlayerHandler.setEmail(state.email!);

  void goToAdminAdrea() => _appRouter.push(const AdminAreaRoute());
}
