part of 'leaderboard_cubit.dart';

@freezed
class LeaderboardState with _$LeaderboardState {
  const factory LeaderboardState.state({User? currentUser, List<User>? users}) =
      _LeaderboardState;
}

extension LeaderboardStateExtension on LeaderboardState {
  int? get currentUserPosition => currentUser != null
      ? (users?.indexWhere((element) => element.email == currentUser!.email) ??
              0) +
          1
      : null;
}
