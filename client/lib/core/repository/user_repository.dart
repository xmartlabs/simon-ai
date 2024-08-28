import 'package:simon_ai/core/common/extension/stream_future_extensions.dart';
import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/source/user_remote_source.dart';
import 'package:stock/stock.dart';

class UserRepository {
  // ignore: unused_field
  final UserRemoteSource _userRemoteSource;

  User? _user;

  final Stock<dynamic, List<User>?> _store;

  UserRepository(this._userRemoteSource)
      : _store = Stock(
          fetcher: Fetcher.ofFuture(
            (_) => _userRemoteSource.getAllUsers(),
          ),
        );

  User? get gameUser => _user;

  void setCurrentUser(User user) => _user = user;

  Stream<List<User>?> getUsers() => _store
      .stream(null)
      .mapToResult()
      .where((event) => event.isSuccess && event.data != null)
      .map((event) => event.data!.requireData());

  Future<void> insertUser(User user) =>
      _userRemoteSource.createUser(user.email, user);

  Future<void> updateUser(User user) async {
    await _userRemoteSource.updateUser(user.email, user);
    _user = user;
  }

  Future<void> deleteUser(String id) => _userRemoteSource.deleteUser(id);

  Future<User?> getUser(String id) => _userRemoteSource.getUser(id);
}
