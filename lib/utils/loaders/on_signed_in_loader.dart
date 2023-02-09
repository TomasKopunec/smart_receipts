import 'package:smart_receipts/utils/loaders/loader.dart';

/// Loader class that runs after the user gets authenticated (Tabs Scaffold initState)
/// This class's logic runs during constructor call
class OnSignedInLoader extends Loader {
  OnSignedInLoader({required super.context, required super.onLoad});

  @override
  void initialise() {
    loadProfile();
    fetchReceipts();
  }

  void loadProfile() {
    users.fetchAndSetUser(auth.token!.accessToken);
  }

  void fetchReceipts() {
    receipt.fetchAndSetFavorites();
  }
}
