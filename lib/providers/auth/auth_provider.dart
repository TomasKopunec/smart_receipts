import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/requests/auth_request_helper.dart';
import 'package:smart_receipts/providers/auth/token.dart';
import 'package:smart_receipts/utils/shared_preferences_helper.dart';

class AuthProvider with ChangeNotifier {
  Token? token;

  AuthRequestHelper authRequestHelper = AuthRequestHelper();

  /* Digital Only */
  bool get isAuthenticated {
    return token != null && (token!.expiresAt.isAfter(DateTime.now()));
  }

  void setToken(Token token) {
    this.token = token;
    SharedPreferencesHelper.setToken(token);
    notifyListeners();
  }

  Future<AuthResponseDTO> register(String email, String password) {
    return authRequestHelper.register(email, password);
  }

  Future<AuthResponseDTO> login(String email, String password) {
    return authRequestHelper.login(email, password);
  }

  Future<bool> logOut() {
    return Future.delayed(const Duration(milliseconds: 500)).then((value) {
      SharedPreferencesHelper.setToken(null);
      token = null;
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
