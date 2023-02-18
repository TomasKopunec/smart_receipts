import 'dart:async';
import 'package:smart_receipts/utils/loaders/loader.dart';

/// Loader class that runs after the user gets authenticated (Tabs Scaffold initState)
/// This class's logic runs during constructor call
class OnSignedInLoader extends Loader {
  OnSignedInLoader({required super.context, required super.onLoad});

  @override
  Future<bool> initialise() async {
    loadProfile();
    loadReceipts();
    loadReturns();
    return true;
  }

  void loadProfile() async {
    return await users.fetchAndSetUser(auth.token!.accessToken);
  }

  void loadReceipts() async {
    return await receipt.fetchAndSetReceipts(auth.token!.accessToken);
  }

  void loadReturns() async {
    return await returns.fetchAndSetReturns(auth.token!.accessToken);
  }
}
