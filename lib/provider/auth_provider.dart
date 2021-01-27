import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus { unAuthenticated, authenticating, authenticated }

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth;
  String message;
  User _user;
  AuthStatus _authStatus = AuthStatus.unAuthenticated;

  AuthProvider(){
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((User user) {
      if(user == null){
        _authStatus = AuthStatus.unAuthenticated;
      }else{
        this._user = user;
        _authStatus = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> registeration({String email, String password}) async {
    try{
      _authStatus = AuthStatus.authenticating;
      notifyListeners();
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _authStatus = AuthStatus.authenticated;
      notifyListeners();
      return true;
    }on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-use'){
        message = 'email-already-in-use';
      }else if(e.code == 'invalid-email'){
        message = 'invalid-email';
      }else if(e.code == 'weak-password'){
        message = 'weak-password';
      }
      _authStatus = AuthStatus.unAuthenticated;
      notifyListeners();
      return false;
    }catch(e){
      message = e.toString();
      _authStatus = AuthStatus.unAuthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _authStatus = AuthStatus.authenticating;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _authStatus = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        message = "Your email is invalid";
      } else if (e.code == 'user-not-found') {
        message = "User not found";
      } else if (e.code == 'wrong-password') {
        message = "Your password is not correct";
      }
      _authStatus = AuthStatus.unAuthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      message = e.toString();
      _authStatus = AuthStatus.unAuthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> log_out() async{
   await _auth.signOut();
   _authStatus = AuthStatus.unAuthenticated;
   notifyListeners();
  }

  User get user => _user;
  AuthStatus get authStatus => _authStatus;
  FirebaseAuth get auth => _auth;

}
