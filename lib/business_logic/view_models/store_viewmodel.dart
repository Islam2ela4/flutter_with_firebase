

import 'file:///C:/Users/infinitu/AndroidStudioProjects/flutterProjects/firbase/lib/services/storage/dataRepository.dart';
import 'file:///C:/Users/infinitu/AndroidStudioProjects/flutterProjects/firbase/lib/services/storage/dataRepositoryImp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase/business_logic/models/user.dart';
import 'package:flutter/cupertino.dart';

enum UpdateStatus { Loading, Loaded }

class Store_ViewModel extends ChangeNotifier{

  UpdateStatus _updateStatus = UpdateStatus.Loaded;
  UpdateStatus get updateStatus => _updateStatus;

  String _errorMessage;
  String get errorMessage => _errorMessage;

  DataRepository repository;
  Store_ViewModel(){
    repository = DataRepositoryImp();
  }

  Future<bool> addNewUser(User user) async{
    try{
      await repository.addUser(user);
      notifyListeners();
      return true;
    }catch(e){
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser(User user) async{
    try{
      _updateStatus = UpdateStatus.Loading;
      notifyListeners();
      await repository.update(user);
      _updateStatus = UpdateStatus.Loaded;
      notifyListeners();
      return true;
    }catch(e){
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<DocumentSnapshot> getUser(String documentId) async{
    return await repository.getCustomUser(documentId);
  }

  Stream<QuerySnapshot> getAllUsers() {
    return repository.getStream();
  }

}