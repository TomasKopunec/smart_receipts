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

  static Future<bool> saveFavorites(List<int> favorites) async {
    return await setStringList(
        key: FAVORITES_LIST,
        value: favorites.map((e) => e.toString()).toList());
  }

  static Future<List<int>> getFavorites() async {
    final prefs = await _instance;

    final List<String>? favs = prefs.getStringList(FAVORITES_LIST);
    return favs == null ? [] : favs.map((e) => int.parse(e)).toList();
  }
}
