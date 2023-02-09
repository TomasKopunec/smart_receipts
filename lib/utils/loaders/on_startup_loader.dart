import 'package:smart_receipts/utils/loaders/loader.dart';
import 'package:smart_receipts/utils/shared_preferences_helper.dart';

/// Loader class that is run single time during the app startup (Splash screen)
/// This class's logic runs in constructor
class OnStartupLoader extends Loader {
  OnStartupLoader({required super.context, required super.onLoad});

  @override
  void initialise() {
    loadAuthentication();
    loadFavouriteReceipts();
    loadSettings();
  }

  void loadSettings() async {
    final loadedSettings = await SharedPreferencesHelper.getSettings();
    final result = settings.loadSettingsFromDto(loadedSettings);

    if (result) {
      log("Settings",
          "Settings loaded successfully: ${loadedSettings.toJson()}");
    } else {
      log("Settings", "Failed to load settings.");
    }
  }

  void loadFavouriteReceipts() async {
    final favourites = await receipt.fetchAndSetFavorites();
    log("Favourite receipts", "Successfully fetched favorites: $favourites");
  }

  void loadAuthentication() async {
    if (!settings.staySignedIn) {
      log("Authentication", "Stay signed is disabled.");
      return;
    }

    // SET TOKEN
    final token = await SharedPreferencesHelper.getToken();
    if (token != null) {
      log("Authentication", "Token found: ${token.toJson()}");
      auth.setToken(token);
    } else {
      log("Authentication", "Token not found.");
    }
  }
}
