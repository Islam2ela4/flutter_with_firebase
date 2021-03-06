import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase/business_logic/models/user.dart';

abstract class DataRepository{
  Stream<QuerySnapshot> getStream();
  Future<DocumentSnapshot> getCustomUser(String documentId);
  Future<void> addUser(User user);
  Future<void> update(User user);
}