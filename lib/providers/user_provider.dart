import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/models/user.dart';

import '../helpers/requests/user_request_helper.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  UserRequestHelper userRequestHelper = UserRequestHelper();

  User? get user {
    return _user;
  }

  void clearUser() {
    _user = null;
  }

  Future<void> fetchAndSetUser(String token) async {
    final response = await userRequestHelper.getUser(token);
    _user = response.user;
    notifyListeners();
  }

  Future<UserResponseDTO> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
    required String newPasswordRepeat,
  }) async {
    return await userRequestHelper.changePassword(
      email: email,
      oldPassword: oldPassword,
      newPassword: newPassword,
      newPasswordRepeat: newPasswordRepeat,
    );
  }

  Future<UserResponseDTO> deleteAccount({
    required String token,
    required String email,
    required String password,
  }) async {
    return await userRequestHelper.deleteAccount(
      token: token,
      email: email,
      password: password,
    );
  }
}
