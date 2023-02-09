import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/requests/user_request_helper.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/widgets/dialogs/dialog_helper.dart';

class ListeningThread {
  final BuildContext context;
  final String accessToken;
  final VoidCallback onFinish;

  final UserProvider users;

  Timer? pingTimer;
  Timer? periodTimer;

  final int oldCount;

  final UserRequestHelper userRequestHelper = UserRequestHelper();

  ListeningThread(
      {required this.context,
      required this.users,
      required this.accessToken,
      required this.onFinish})
      : oldCount = users.user!.count {
    // Listen for one minute
    periodTimer = Timer(const Duration(minutes: 1), () {
      clear();
    });

    // Ping every 5 seconds
    pingTimer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      onPingTick();
    });

    print(
        "[${runtimeType.toString().toUpperCase()}] Listening for receipt updates started.");
  }

  void onPingTick() {
    users.fetchAndSetUser(context, accessToken).then((value) {
      if (users.user!.count > oldCount) {
        print(
            "[${runtimeType.toString().toUpperCase()}] Received new receipt.");
        final provider = Provider.of<ReceiptsProvider>(context, listen: false);
        DialogHelper.showReceivedNewReceipt(context, provider.getMostRecent());
        clear();
      }
    });
  }

  void clear() {
    pingTimer!.cancel();
    periodTimer!.cancel();
    onFinish();
    print("[${runtimeType.toString().toUpperCase()}] Successfully canceled.");
  }
}
