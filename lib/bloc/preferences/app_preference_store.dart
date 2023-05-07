
abstract class IAppPreferenceStore {
  Future<void> init();

  //bool reset();
  Map<String, dynamic> all();

  void setString(String key, String value);
  void setBool(String key, bool value);
  void setDouble(String key, double value);
  void setInt(String key, int value);

  dynamic get(String key);
  String? getString(String key);
  bool? getBool(String key);
  int? getInt(String key);
  double? getDouble(String key);
  void remove(String key);

  void set(String key, dynamic value) {
    if (value == null) {
      remove(key);
    } else if (value is String) {
      setString(key, value);
    } else if (value is bool) {
      setBool(key, value);
    } else if (value is int) {
      setInt(key, value);
    } else if (value is double) {
      setDouble(key, value);
    } else {
      throw UnimplementedError(
          "The type provided is not a valid type ${value.runtimeType}");
    }
  }
}
