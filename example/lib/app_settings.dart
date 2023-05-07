import 'package:flutter_model/bloc/preferences/app_preference.dart';

class AppSettings extends IAppPreference {
  static const String prefKeyLanguageCode = "global.language";
  //static const String prefKeyTheme = "global.theme";
  static const String prefKeyDarkMode = "global.darkmode";
  static const String prefKeyEnableTest = "global.enable.test";
  static const String prefKeyHaveCompletedWelcome =
      "global.havecompletedwelcome";
  static const String prefPanelWeatherShowSummaryKey =
      "global.havecompletedwelcome";

  AppSettings([super.values]);

  bool get testMode => getBool(prefKeyEnableTest) ?? false;
  bool get darkMode => getBool(prefKeyDarkMode) ?? false;
  String get languageCode => getString(prefKeyLanguageCode) ?? "en";
  bool get haveCompletedWelcome =>
      getBool(prefKeyHaveCompletedWelcome) ?? false;
  bool get panelWeatherShowSummary =>
      getBool(prefPanelWeatherShowSummaryKey) ?? false;
  @override
  dynamic copyWith(Map<String, dynamic> newValues) {
    //merge
    var merged = merge(newValues);
    return AppSettings(merged);
  }
}
