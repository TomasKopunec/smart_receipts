import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/models/user.dart';

import '../helpers/requests/user_request_helper.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  UserRequestHelper userRequestHelper = UserRequestHelper();

  /* USER */
  User? get user {
    return _user;
  }

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void fetchAndSetUser(String token) async {
    final response = await userRequestHelper.getUser(token);
    setUser(response.user);
  }
}
