import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/common/extension/app_router_extensions.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/ui/router/app_router.dart';

part 'admin_area_state.dart';

part 'admin_area_cubit.freezed.dart';

class AdminAreaCubit extends Cubit<AdminAreaState> {
  final SessionRepository _sessionRepository = DiProvider.get();
  final AppRouter _appRouter = DiProvider.get();

  StreamSubscription? _emailSubscription;
  AdminAreaCubit() : super(const AdminAreaState.state()) {
    initData();
  }

  @override
  Future<void> close() {
    _emailSubscription?.cancel();
    return super.close();
  }

  void initData() {
    _emailSubscription = _sessionRepository.currentUserEmail.listen((email) {
      emit(state.copyWith(currentUserEmail: email));
    });
  }

  void changeEmail(String? email) => emit(state.copyWith(email: email));

  void changePassword(String? password) =>
      emit(state.copyWith(password: password));

  bool get isFormValid => state.email != null && state.password != null;

  Future<void> signIn() async {
    final res = await _sessionRepository.signInUser(
      email: state.email!,
      password: state.password!,
    );
    if (res.isFailure) {
      emit(state.copyWith(error: 'Invalid email or password'));
    }
    if (res.isSuccess) {
      await _appRouter.popTopMost();
    }
  }

  Future<void> signOut() async {
    await _sessionRepository.logOut();
  }
}
