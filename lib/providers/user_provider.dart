import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/models/user.dart';

import '../helpers/requests/user_request_helper.dart';
import 'receipts/receipts_provider.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  UserRequestHelper userRequestHelper = UserRequestHelper();

  /* USER */
  User? get user {
    return _user;
  }

  void setUser(User? user, BuildContext context) {
    _user = user;
    Provider.of<ReceiptsProvider>(context, listen: false)
        .setReceipts(user!.receipts);
    notifyListeners();
  }

  Future<void> fetchAndSetUser(BuildContext context, String token) async {
    final response = await userRequestHelper.getUser(token);
    setUser(response.user, context);
  }
}
