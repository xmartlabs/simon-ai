import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/services/firestore_db.dart';

class UserRemoteSource {
  final FirestoreDb _firestoreDb =
      FirestoreDb(collection: 'ranking', subCollection: 'players');
  UserRemoteSource();

  Future<void> createUser(String id, User data, String createdBy) async {
    await _firestoreDb.insert(
      id: id,
      data: data.toJson(),
      createdBy: createdBy,
    );
  }

  Future<User?> getUser(String id) async =>
      User.fromJson((await _firestoreDb.getData(id))!);

  Future<void> updateUser(String id, User data, String createdBy) async {
    await _firestoreDb.update(
      id: id,
      data: data.toJson(),
      createdBy: createdBy,
    );
  }

  Future<void> deleteUser(String id) async {
    await _firestoreDb.delete(id);
  }

  Future<List<User>> getAllUsers(String createdBy) async =>
      (await _firestoreDb.getAllData(createdBy))
          .map((e) => User.fromJson(e))
          .toList();

  Future<void> close() => _firestoreDb.close();
}
