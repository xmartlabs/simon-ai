import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/services/firestore_db.dart';

class UserRemoteSource extends FirestoreDb<User> {
  UserRemoteSource({required super.modelToJson, required super.jsonToModel});
}
