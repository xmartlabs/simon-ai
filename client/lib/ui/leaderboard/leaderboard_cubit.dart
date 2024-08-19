import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/repository/user_repository.dart';
import 'package:simon_ai/ui/router/app_router.dart';

part 'leaderboard_state.dart';

part 'leaderboard_cubit.freezed.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final AppRouter _appRouter = DiProvider.get();
  final UserRepository _userRepository = DiProvider.get();

  late StreamSubscription<List<User>?> _leaderboardSubscription;
  LeaderboardCubit() : super(const LeaderboardState.state()) {
    fetchLeaderboard();
  }

  void fetchLeaderboard() {
    emit(state.copyWith(currentUser: _userRepository.gameUser));
    _leaderboardSubscription = _userRepository.getUsers().listen((users) {
      emit(
        state.copyWith(
          users: users
            ?..sort((user1, user2) => user2.points.compareTo(user1.points)),
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _leaderboardSubscription.cancel();
    return super.close();
  }

  Future<void> onRestartPressed() =>
    _appRouter.replaceAll([const RegisterUserRoute()]);
  
}
