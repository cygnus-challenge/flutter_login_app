import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage(this._prefs);
  final SharedPreferences _prefs;

  // --- GENERIC GET & SAVE OBJECT ---

  // 1. Generic Get Object
  T? getObj<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final str = _prefs.getString(key);
    if (str == null) return null;
    try {
      return fromJson(jsonDecode(str));
    } catch (_) {
      return null;
    }
  }

  // 2. Generic Save Object
  Future<bool> saveObj<T>(String key, T value, Map<String, dynamic> Function(T) toJson) {
    return _prefs.setString(key, jsonEncode(toJson(value)));
  }

  // 3. Generic Get Object List
  List<T>? getObjList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final listStr = _prefs.getStringList(key);
    if (listStr == null) return null;
    try {
      return listStr.map((str) => fromJson(jsonDecode(str))).toList();
    } catch (_) {
      return null;
    }
  }

  // 4. Generic Save Object List
  Future<bool> saveObjecList<T>(String key, List<T> list, Map<String, dynamic> Function(T) toJson) {
    final listStr = list.map((item) => jsonEncode(toJson(item))).toList();
    return _prefs.setStringList(key, listStr);
  }


  // String? getString(String key) => _prefs.getString(key);

  // Future<bool> saveString(String key, String value) => _prefs.setString(key, value);

  // List<String>? getStringList(String key) => _prefs.getStringList(key);

  // Future<bool> saveStringList(String key, List<String> value) => _prefs.setStringList(key, value);
}
