import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth/token.dart';
import '../providers/settings/settings_dto.dart';

class SharedPreferencesHelper {
  static const String favoritesList = '/FAVORITES_LIST';

  static Future<SharedPreferences> get _instance async {
    return SharedPreferences.getInstance();
  }

  static Future<bool> clearAll() async {
    await saveSettings(const SettingsDto());
    await saveFavorites([]);
    await setToken(null);
    return true;
  }

  static Future<SettingsDto> getSettings() async {
    final prefs = await _instance;
    final settings = prefs.getString("settings");

    // If no settings found, return default settings
    if (settings == null || settings.isEmpty) {
      return const SettingsDto();
    } else {
      return SettingsDto.fromJson(json.decode(settings));
    }
  }

  static Future<bool> saveSettings(SettingsDto settingsDto) async {
    final prefs = await _instance;
    return prefs.setString("settings", json.encode(settingsDto.toJson()));
  }

  static Future<bool> setStringList(
      {required String key, required List<String> value}) async {
    final prefs = await _instance;
    final res = await prefs.setStringList(key, value);
    return res;
  }

  static Future<bool> saveFavorites(List<String> favorites) async {
    return await setStringList(key: favoritesList, value: favorites);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await _instance;

    final List<String>? favs = prefs.getStringList(favoritesList);
    return favs ?? [];
  }

  static Future<void> setToken(Token? token) async {
    final prefs = await _instance;

    await prefs.setString(
        "token", token == null ? "" : json.encode(token.toJson()));
  }

  static Future<Token?> getToken() async {
    final prefs = await _instance;

    final res = prefs.getString("token");
    if (res == null || res.isEmpty) {
      return null;
    } else {
      return Token.fromJson(json.decode(prefs.getString("token")!));
    }
  }
}
