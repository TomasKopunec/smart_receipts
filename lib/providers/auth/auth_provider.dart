import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {
  bool _isSignedIn = false;

  /* Digital Only */
  bool get signedIn {
    return _isSignedIn;
  }

  Future<bool> signIn(String username, String password) {
    return Future.delayed(Duration(milliseconds: 500)).then((value) {
      _isSignedIn = true;
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<bool> signOut() {
    return Future.delayed(Duration(milliseconds: 500)).then((value) {
      _isSignedIn = false;
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<bool> changePassword(String email) {
    return Future.delayed(Duration(seconds: 1)).then((value) {
      return true;
    }).onError((error, stackTrace) => false);
  }
}
