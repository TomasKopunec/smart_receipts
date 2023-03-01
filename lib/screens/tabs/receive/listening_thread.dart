import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/requests/user_request_helper.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/utils/logger.dart';
import 'package:smart_receipts/widgets/dialogs/dialog_helper.dart';

class ListeningThread {
  final Logger logger = Logger(ListeningThread);

  final BuildContext context;
  final VoidCallback onFinish;

  final UserProvider users;
  final AuthProvider auth;

  Timer? pingTimer;
  Timer? periodTimer;

  final int oldCount;

  final UserRequestHelper userRequestHelper = UserRequestHelper();

  ListeningThread({
    required this.context,
    required this.users,
    required this.auth,
    required this.onFinish,
  }) : oldCount = users.user!.count {
    // Listen for one minute
    periodTimer = Timer(const Duration(minutes: 2), () {
      clear();
    });

    // Ping every 3 seconds
    pingTimer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      onPingTick();
    });

    // Do an initial call
    onPingTick();

    logger.log("Listening Thread for receipt updates started. (3s)");
  }

  void onPingTick() async {
    if (!auth.isAuthenticated) {
      clear();
    }

    final token = auth.token!.accessToken;
    users.fetchAndSetUser(token).then((value) {
      logger.log("Pinging receipts");
      if (users.user == null) {
        return;
      }
      if (users.user!.count > oldCount) {
        logger.log("Received new receipt.");
        clear();
        final provider = Provider.of<ReceiptsProvider>(context, listen: false);
        provider.fetchAndSetReceipts(token).then((value) =>
            DialogHelper.showReceivedNewReceipt(
                context, provider.getMostRecent()));
      }
    });
  }

  void clear() {
    pingTimer!.cancel();
    periodTimer!.cancel();
    onFinish();
    logger.log("Successfully canceled Listening Thread.");
  }
}
