import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/services/firestore_db.dart';

class UserRemoteSource {
  final FirestoreDb _firestoreDb = FirestoreDb(collection: 'users');
  UserRemoteSource();

  Future<void> createUser(String id, User data) async {
    await _firestoreDb.insert(id: id, data: data.toJson());
  }

  Future<User?> getUser(String id) async =>
      User.fromJson((await _firestoreDb.getData(id))!);

  Future<void> updateUser(String id, User data) async {
    await _firestoreDb.update(id: id, data: data.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _firestoreDb.delete(id);
  }

  Future<List<User>> getAllUsers() async =>
      (await _firestoreDb.getAllData()).map((e) => User.fromJson(e)).toList();

  Future<void> close() async {
    await _firestoreDb.close();
  }
}
