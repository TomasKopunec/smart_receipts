import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/requests/auth_request_helper.dart';
import 'package:smart_receipts/providers/auth/token.dart';
import 'package:smart_receipts/helpers/shared_preferences_helper.dart';

import '../../utils/logger.dart';

class AuthProvider with ChangeNotifier {
  Logger logger = Logger(AuthProvider);
  Token? _token;

  AuthRequestHelper authRequestHelper = AuthRequestHelper();

  /* Digital Only */
  bool get isAuthenticated {
    logger.log("_token != null ? ${_token != null}");
    logger.log("DateTime.now() = ${DateTime.now()}");
    logger
        .log("token.expiresAt = ${_token != null ? _token!.expiresAt : null}");
    logger.log(
        "Comparison = ${_token != null ? (DateTime.now().isBefore(_token!.expiresAt)) : null}");

    return _token != null && (DateTime.now().isBefore(_token!.expiresAt));
  }

  Token? get token {
    return _token;
  }

  void setToken(Token? token) async {
    _token = token;
    await SharedPreferencesHelper.setToken(token); // Update the memory
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
