import 'package:shared_preferences/shared_preferences.dart';

// Storage Helper
class LocalStorage {
  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.remove(key);
    }
    return null;
  }

  getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.getString(key);
    }
    return null;
  }

  setString(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.getInt(key);
    }
    return null;
  }

  setInt(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}
