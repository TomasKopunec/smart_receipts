import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/requests/auth_request_helper.dart';
import 'package:smart_receipts/providers/auth/token.dart';
import 'package:smart_receipts/helpers/shared_preferences_helper.dart';

class AuthProvider with ChangeNotifier {
  Token? _token;

  AuthRequestHelper authRequestHelper = AuthRequestHelper();

  /* Digital Only */
  bool get isAuthenticated {
    print("_token != null ? ${_token != null}");
    print(
        "_token!.expiresAt.isAfter(DateTime.now()) ? ${_token!.expiresAt.isAfter(DateTime.now())}");
    print("isAuthenticated: $_token");
    return _token != null;
  }

  Token? get token {
    return _token;
  }

  void setToken(Token? token) async {
    print("setToken($token)");
    _token = token;
    print("Token updated");
    await SharedPreferencesHelper.setToken(token); // Update the memory
    print("Token stored in memory.");
    notifyListeners();
    print("Listeners notified.");
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
