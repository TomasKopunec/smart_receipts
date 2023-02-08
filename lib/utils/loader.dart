import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_dto.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/utils/shared_preferences_helper.dart';

import '../providers/auth/auth_provider.dart';
import '../providers/user_provider.dart';

/// Loader class that is run single time during the app startup (Splash screen)
/// This class's logic runs in constructor
class Loader {
  final BuildContext context;

  Loader(this.context, Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadAuthentication();
      loadFavouriteReceipts();
      loadSettings();
      callback();
    });
  }

  void loadSettings() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final loadedSettings = await SharedPreferencesHelper.getSettings();
    final result = settings.loadSettingsFromDto(loadedSettings);

    if (result) {
      _log("Settings",
          "Settings loaded successfully: ${loadedSettings.toJson()}");
    } else {
      _log("Settings", "Failed to load settings.");
    }
  }

  void loadFavouriteReceipts() async {
    final receipts = Provider.of<ReceiptsProvider>(context, listen: false);
    final favourites = await receipts.fetchAndSetFavorites();
    _log("Favourite receipts", "Successfully fetched favorites: $favourites");
  }

  void loadAuthentication() async {
    if (!Provider.of<SettingsProvider>(context, listen: false).staySignedIn) {
      _log("Authentication", "Stay signed is disabled.");

      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);

    // SET TOKEN
    final token = await SharedPreferencesHelper.getToken();
    if (token != null) {
      _log("Authentication", "Token found: ${token.toJson()}");
      auth.setToken(token);

      // Load user
      Provider.of<UserProvider>(context, listen: false)
          .fetchAndSetUser(token.accessToken);
    } else {
      _log("Authentication", "Token not found.");
    }
  }

  void loadProfile(AuthProvider auth) {}

  void _log(String title, String body) {
    print("[LOADER] ${title.toUpperCase()}: $body");
  }
}
