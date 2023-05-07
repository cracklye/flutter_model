import 'package:flutter_model/bloc/preferences/app_preference_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefStoreSharedPreferences extends IAppPreferenceStore {
  late SharedPreferences preferences;
  @override
  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void remove(String key) {
    preferences.remove(key);
  }

  @override
  Map<String, dynamic> all() {
    Map<String, dynamic> rtn = {};
    for (var key in preferences.getKeys()) {
      rtn.putIfAbsent(key, () => preferences.get(key));
    }
    return rtn;
  }

  @override
  void setString(String key, String value) {
    preferences.setString(key, value);
  }

  @override
  void setBool(String key, bool value) {
    preferences.setBool(key, value);
  }

  @override
  void setDouble(String key, double value) {
    preferences.setDouble(key, value);
  }

  @override
  void setInt(String key, int value) {
    preferences.setInt(key, value);
  }

  @override
  dynamic get(String key) {
    return preferences.get(key);
  }

  @override
  String? getString(String key) {
    return preferences.getString(key);
  }

  @override
  bool? getBool(String key) {
    return preferences.getBool(key);
  }

  @override
  int? getInt(String key) {
    return preferences.getInt(key);
  }

  @override
  double? getDouble(String key) {
    return preferences.getDouble(key);
  }
}
