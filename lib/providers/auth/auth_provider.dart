import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/requests/auth_request_helper.dart';
import 'package:smart_receipts/providers/auth/token.dart';
import 'package:smart_receipts/utils/shared_preferences_helper.dart';

class AuthProvider with ChangeNotifier {
  Token? _token;

  AuthRequestHelper authRequestHelper = AuthRequestHelper();

  /* Digital Only */
  bool get isAuthenticated {
    return _token != null && (_token!.expiresAt.isAfter(DateTime.now()));
  }

  Token? get token {
    return _token;
  }

  void setToken(Token? token) {
    _token = token;
    SharedPreferencesHelper.setToken(token);
    notifyListeners();
  }

  Future<AuthResponseDTO> register(String email, String password) {
    return authRequestHelper.register(email, password);
  }

  Future<AuthResponseDTO> login(String email, String password) {
    return authRequestHelper.login(email, password);
  }

  Future<bool> logout() async {
    return authRequestHelper.logout(_token!.accessToken);
  }

  Future<bool> changePassword(String email) {
    return Future.delayed(const Duration(seconds: 1)).then((value) {
      return true;
    }).onError((error, stackTrace) => false);
  }
}
