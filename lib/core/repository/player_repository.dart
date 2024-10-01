import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/common/result.dart';
import 'package:simon_ai/core/model/player.dart';
import 'package:simon_ai/core/source/auth_local_source.dart';
import 'package:simon_ai/core/source/user_remote_source.dart';
import 'package:stock/stock.dart';

class PlayerRepository {
  // ignore: unused_field
  final UserRemoteSource _userRemoteSource;
  final AuthLocalSource _authLocalSource;

  final Stock<String, List<Player>?> _store;
  final defaultId = 'default';

  PlayerRepository(this._userRemoteSource, this._authLocalSource)
      : _store = Stock(
          fetcher: Fetcher.ofFuture(
            (createdBy) => _userRemoteSource.getAllUsers(createdBy),
          ),
        );

  Stream<List<Player>?> getPlayers() {
    final userTokenStream = _authLocalSource.getUserToken();
    return userTokenStream.switchMap(
      (createdBy) => _store
          .stream(createdBy ?? defaultId)
          .where((event) => event.isData)
          .map((event) => event.requireData()),
    );
  }

  Future<Result<Player>> setPlayer(Player player) =>
      Result.fromFuture(() async {
        final userId = await _authLocalSource.getUserToken().first;
        await _userRemoteSource.createUser(
          player.email,
          player,
          userId ?? defaultId,
        );
        await _authLocalSource.saveCurrentPlayer(player);
        return player;
      });

  Future<Result<void>> updatePoints(int points) => Result.fromFuture(() async {
        final userId = await _authLocalSource.getUserToken().first;
        final player =
            (await getCurrentPlayer().first)!.copyWith(points: points);
        await _userRemoteSource.updateUser(
          player.email,
          player,
          userId ?? defaultId,
        );
        await _authLocalSource.saveCurrentPlayer(player);
      });

  Future<Player?> getPlayer(String email) => _userRemoteSource.getUser(email);

  Stream<Player?> getCurrentPlayer() => _authLocalSource.getCurrentPlayer();
}
