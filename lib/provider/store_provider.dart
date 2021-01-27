
import 'package:firbase/model/user.dart';
import 'package:firbase/repository/dataRepository.dart';
import 'package:firbase/repository/dataRepositoryImp.dart';
import 'package:flutter/cupertino.dart';

enum UpdateStatus { Loading, Loaded }

class StoreProvider extends ChangeNotifier{

  UpdateStatus _updateStatus = UpdateStatus.Loaded;
  UpdateStatus get updateStatus => _updateStatus;

  String _errorMessage;
  String get errorMessage => _errorMessage;

  DataRepository repository;
  StoreProvider(){
    repository = DataRepositoryImp();
  }

  // Future<bool> addnewUser(User user) async{
  //   try{
  //     await repository.addUser(user);
  //     notifyListeners();
  //     return true;
  //   }catch(e){
  //     _errorMessage = e.toString();
  //     notifyListeners();
  //     return false;
  //   }
  // }

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
}