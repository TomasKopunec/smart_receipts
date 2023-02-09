import 'dart:async';

import 'package:smart_receipts/utils/loaders/loader.dart';

/// Loader class that runs after the user gets authenticated (Tabs Scaffold initState)
/// This class's logic runs during constructor call
class OnSignedInLoader extends Loader {
  OnSignedInLoader({required super.context, required super.onLoad});

  @override
  Future<bool> initialise() async {
    loadProfile();
    return true;
  }

  Future<void> loadProfile() {
    return users.fetchAndSetUser(context, auth.token!.accessToken);
  }
}
