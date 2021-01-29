
import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Users/infinitu/AndroidStudioProjects/flutterProjects/firbase/lib/services/storage/dataRepository.dart';
import 'package:firbase/business_logic/models/user.dart';

class DataRepositoryImp extends DataRepository {

  final CollectionReference collection = FirebaseFirestore.instance.collection(
      'users');

  @override
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  @override
  Future<DocumentSnapshot> getCustomUser(String documentId) async {
    return await collection.doc(documentId).get();
  }

  @override
  Future<void> addUser(User user) async {
    // return collection.add(user.toJson());
    //DocumentReference
    // for custom doc id
    await collection.doc(user.id).set(user.toJson());
  }

  @override
  Future<void> update(User user) async {
    await collection.doc(user.id).update(user.toJson());
  }

}