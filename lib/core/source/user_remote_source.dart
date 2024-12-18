import 'package:simon_ai/core/model/player.dart';
import 'package:simon_ai/core/services/firestore_db.dart';

class UserRemoteSource {
  final FirestoreRankingDb _firestoreDb =
      FirestoreRankingDb(collection: 'ranking', subCollection: 'players');

  UserRemoteSource();

  Future<void> createUser(String id, Player data) async {
    await _firestoreDb.insert(
      id: id,
      data: data.toJson(),
    );
  }

  Future<Player?> getUser(String id) => _firestoreDb
      .getData(id)
      .then((value) => value == null ? null : Player.fromJson(value));

  Future<void> updateUser(String id, Player data) => _firestoreDb.update(
        id: id,
        data: data.toJson(),
      );

  Future<void> deleteUser(String id) async {
    await _firestoreDb.delete(id);
  }

  Future<List<Player>> getAllUsers() async =>
      (await _firestoreDb.getAllData()).map((e) => Player.fromJson(e)).toList();

  Future<void> close() => _firestoreDb.close();
}
