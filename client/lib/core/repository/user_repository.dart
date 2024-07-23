import 'package:simon_ai/core/common/extension/stream_future_extensions.dart';
import 'package:simon_ai/core/interfaces/db_interface.dart';
import 'package:simon_ai/core/model/user.dart';
import 'package:stock/stock.dart';

class UserRepository {
  // ignore: unused_field
  final DbInterface<User> _userRemoteSource;

  final Stock<dynamic, List<User>?> _store;

  UserRepository(this._userRemoteSource)
      : _store = Stock(
          fetcher: Fetcher.ofFuture(
            (_) => _userRemoteSource.getAllData('users'),
          ),
        );

  Stream<List<User>?> getUsers() => _store
      .stream(null)
      .mapToResult()
      .where((event) => event.isSuccess && event.data != null)
      .map((event) => event.data!.requireData());
}
