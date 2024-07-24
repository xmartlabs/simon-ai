import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simon_ai/core/interfaces/db_interface.dart';

abstract class FirestoreDb<Model> implements DbInterface<Model> {
  late final FirebaseFirestore _firestore;
  final Map<String, dynamic> Function(Model) modelToJson;
  final Model Function(Map<String, dynamic>) jsonToModel;

  FirestoreDb({required this.modelToJson, required this.jsonToModel}) {
    init();
  }

  @override
  Future<void> init() async {
    _firestore = FirebaseFirestore.instance;
  }

  @override
  Future<void> close() async => _firestore.terminate();

  @override
  Future<void> delete(String collection, String id) =>
      _firestore.collection(collection).doc(id).delete();

  @override
  Future<List<Model>> getAllData(String collection) async {
    final snapshot = await _firestore.collection(collection).get();
    return snapshot.docs.map((doc) => jsonToModel(doc.data())).toList();
  }

  @override
  Future<void> insert(String collection, String id, Model data) =>
      _firestore.collection(collection).doc(id).set(modelToJson(data));

  @override
  Future<void> update(String collection, String id, Model newData) =>
      _firestore.collection(collection).doc(id).update(modelToJson(newData));

  @override
  Future<Model?> getData(String collection, String id) async {
    final snapshot = await _firestore.collection(collection).doc(id).get();
    if (snapshot.exists) {
      return jsonToModel(snapshot.data()!);
    }
    return null;
  }
}
