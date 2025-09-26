
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences once at app start
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save boolean
  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  // Get boolean
  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  // Save string
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  // Get string
  static String getString(String key, {String defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }
static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key , value);
  }

   static int getInt(String key, {int defaultValue = 1}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }
  // Remove key
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  // Clear all preferences
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
