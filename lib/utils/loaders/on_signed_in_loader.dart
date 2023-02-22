import 'dart:async';
import 'package:smart_receipts/utils/loaders/loader.dart';

/// Loader class that runs after the user gets authenticated (Tabs Scaffold initState)
/// This class's logic runs during constructor call
class OnSignedInLoader extends Loader {
  OnSignedInLoader({required super.context, required super.onLoad});

  @override
  Future<bool> initialise() async {
    await loadProfile();
    await loadReceipts();
    await loadReturns();
    return true;
  }

  Future<void> loadProfile() async {
    return users.fetchAndSetUser(auth.token!.accessToken);
  }

  Future<void> loadReceipts() async {
    return receipt.fetchAndSetReceipts(auth.token!.accessToken);
  }

  Future<void> loadReturns() async {
    return returns.fetchAndSetReturns(auth.token!.accessToken);
  }
}
