import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simon_ai/core/interfaces/db_interface.dart';

interface class FirestoreRankingDb
    implements DbInterface<Map<String, dynamic>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String collection;
  final String subCollection;
  final defaultId = 'default';

  FirestoreRankingDb({
    required this.collection,
    required this.subCollection,
  });

  CollectionReference<Map<String, dynamic>> _getCollectionReference() {
    final user = _auth.currentUser;
    return _firestore
        .collection(collection)
        .doc(user?.uid ?? defaultId)
        .collection(subCollection);
  }

  @override
  Future<void> close() async => _firestore.terminate();

  @override
  Future<void> delete(String id) => _getCollectionReference().doc(id).delete();

  @override
  Future<List<Map<String, dynamic>>> getAllData() async {
    final snapshot = await _getCollectionReference().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> insert({
    required String id,
    required Map<String, dynamic> data,
  }) =>
      _getCollectionReference().doc(id).set(data);

  @override
  Future<void> update({
    required String id,
    required Map<String, dynamic> data,
  }) =>
      _getCollectionReference().doc(id).update(data);

  @override
  Future<Map<String, dynamic>?> getData(String userId) async {
    final snapshot = await _getCollectionReference().doc(userId).get();
    if (snapshot.exists) {
      return snapshot.data();
    }
    return null;
  }
}
