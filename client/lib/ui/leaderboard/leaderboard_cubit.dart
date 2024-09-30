import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/player.dart';
import 'package:simon_ai/core/repository/player_repository.dart';
import 'package:simon_ai/ui/router/app_router.dart';

part 'leaderboard_cubit.freezed.dart';
part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final AppRouter _appRouter = DiProvider.get();
  final PlayerRepository _userRepository = DiProvider.get();

  late StreamSubscription<List<Player>?> _leaderboardSubscription;

  LeaderboardCubit() : super(const LeaderboardState.state()) {
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    emit(
      state.copyWith(
        currentUser: await _userRepository.getCurrentPlayer().first,
      ),
    );
    _leaderboardSubscription = _userRepository.getPlayers().listen((users) {
      emit(
        state.copyWith(
          users: users
            ?..sort((user1, user2) => user2.points.compareTo(user1.points)),
        ),
      );
    });
  }

  @override
  Future<void> close() async {
    await _leaderboardSubscription.cancel();
    return super.close();
  }

  Future<void> restartGame() =>
      _appRouter.replaceAll([const RegisterPlayerEmailRoute()]);
}
