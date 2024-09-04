import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/source/auth_local_source.dart';
import 'package:simon_ai/core/source/user_remote_source.dart';
import 'package:stock/stock.dart';

class UserRepository {
  // ignore: unused_field
  final UserRemoteSource _userRemoteSource;
  final AuthLocalSource _authLocalSource;

  User? _user;

  final Stock<String, List<User>?> _store;

  UserRepository(this._userRemoteSource, this._authLocalSource)
      : _store = Stock(
          fetcher: Fetcher.ofFuture(
            (createdBy) => _userRemoteSource.getAllUsers(createdBy),
          ),
        );

  User? get gameUser => _user;

  void setCurrentUser(User user) => _user = user;

  Stream<List<User>?> getUsers() {
    final userTokenStream = _authLocalSource.getUserToken();
    return userTokenStream.switchMap(
      (createdBy) => _store
          .stream(createdBy ?? '')
          .where((event) => event.isData)
          .map((event) => event.requireData()),
    );
  }

  Future<void> insertUser(User user) =>
      _userRemoteSource.createUser(user.email, user);

  Future<void> updateUser(User user) async {
    await _userRemoteSource.updateUser(user.email, user);
    _user = user;
  }

  Future<void> deleteUser(String id) => _userRemoteSource.deleteUser(id);

  Future<User?> getUser(String id) => _userRemoteSource.getUser(id);
}
