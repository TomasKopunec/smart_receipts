import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String FAVORITES_LIST = '/FAVORITES_LIST';

  static Future<SharedPreferences> get _instance async {
    return SharedPreferences.getInstance();
  }

  static Future<bool> setStringList(
      {required String key, required List<String> value}) async {
    final prefs = await _instance;
    final res = await prefs.setStringList(key, value);
    return res;
  }

  static Future<bool> saveFavorites(List<String> favorites) async {
    return await setStringList(key: FAVORITES_LIST, value: favorites);
  }

  static Future<List<String>?> getFavorites() async {
    final prefs = await _instance;
    return prefs.getStringList(FAVORITES_LIST);
  }
}
