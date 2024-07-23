import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simon_ai/core/interfaces/db_interface.dart';
import 'package:simon_ai/core/model/user.dart';

class FirestoreDb implements DbInterface<User> {
  late final FirebaseFirestore _firestore;

  @override
  Future<void> close() async => _firestore.terminate();

  @override
  Future<void> delete(String collection, String id) =>
      _firestore.collection(collection).doc(id).delete();

  @override
  Future<List<User>> getAllData(String collection) async {
    final snapshot = await _firestore.collection(collection).get();
    return snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
  }

  @override
  Future<void> init() async {
    _firestore = FirebaseFirestore.instance;
  }

  @override
  Future<void> insert(String collection, User data) =>
      _firestore.collection(collection).add(data.toJson());

  @override
  Future<void> update(String collection, String id, User newData) =>
      _firestore.collection(collection).doc(id).update(newData.toJson());

  @override
  Future<User?> getData(String collection, String id) async {
    final snapshot = await _firestore.collection(collection).doc(id).get();
    if (snapshot.exists) {
      return User.fromJson(snapshot.data()!);
    }
    return null;
  }
}
