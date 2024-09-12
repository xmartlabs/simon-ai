import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simon_ai/core/interfaces/db_interface.dart';

interface class FirestoreDb implements DbInterface<Map<String, dynamic>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String collection;
  final String subCollection;

  FirestoreDb({
    required this.collection,
    required this.subCollection,
  });

  @override
  Future<void> close() async => _firestore.terminate();

  @override
  Future<void> delete(String id) =>
      _firestore.collection(collection).doc(id).delete();

  @override
  Future<List<Map<String, dynamic>>> getAllData(String createdBy) async {
    final snapshot = await _firestore
        .collection(collection)
        .doc(createdBy)
        .collection(subCollection)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> insert({
    required String id,
    required Map<String, dynamic> data,
    required String createdBy,
  }) =>
      _firestore
          .collection(collection)
          .doc(createdBy)
          .collection(subCollection)
          .doc(id)
          .set(data);

  @override
  Future<void> update({
    required String id,
    required Map<String, dynamic> data,
    required String createdBy,
  }) =>
      _firestore
          .collection(collection)
          .doc(createdBy)
          .collection(subCollection)
          .doc(id)
          .update(data);

  @override
  Future<Map<String, dynamic>?> getData(String id) async {
    final snapshot = await _firestore.collection(collection).doc(id).get();
    if (snapshot.exists) {
      return snapshot.data();
    }
    return null;
  }
}
