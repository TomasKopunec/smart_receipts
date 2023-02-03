import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/requests/auth_request_helper.dart';
import 'package:smart_receipts/helpers/requests/response.dart';

class AuthProvider with ChangeNotifier {
  AuthRequestHelper authRequestHelper = AuthRequestHelper();

  bool _isSignedIn = false;

  /* Digital Only */
  bool get signedIn {
    return _isSignedIn;
  }

  Future<AuthResponseDTO> register(String email, String password) {
    return authRequestHelper.register(email, password);
  }

  Future<AuthResponseDTO> login(String email, String password) {
    return authRequestHelper.login(email, password);
  }

  Future<bool> logOut() {
    return Future.delayed(const Duration(milliseconds: 500)).then((value) {
      _isSignedIn = false;
      notifyListeners();
      return true;
    }).onError((error, stackTrace) {
      return false;
    });
  }

  Future<bool> changePassword(String email) {
    return Future.delayed(const Duration(seconds: 1)).then((value) {
      return true;
    }).onError((error, stackTrace) => false);
  }
}
