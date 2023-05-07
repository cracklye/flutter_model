// // import 'package:forecast_app/app_environement.dart';
// // import 'package:freezed_annotation/freezed_annotation.dart';

// // part 'app_settings.g.dart';
// // part 'app_settings.freezed.dart';

// // @freezed
// // class AppSettings with _$AppSettings, IAppPreference {
// //   AppSettings._();
// //   static const String prefKeyLanguageCode = "global.language";
// //   static const String prefKeyTheme = "global.theme";
// //   static const String prefKeyEnableTest = "global.enable.test";

// //   factory AppSettings({
// //     @Default(false) bool testMode,
// //     @Default("en-uk") String language,
// //     @Default("light") String theme,
// //   }) = _AppSettings;

// //   factory AppSettings.fromJson(Map<String, dynamic> values) =>
// //       _$AppSettingsFromJson(values);
// // }
// class AppSettings extends IAppPreference {
//   static const String prefKeyLanguageCode = "global.language";
//   //static const String prefKeyTheme = "global.theme";
//   static const String prefKeyDarkMode = "global.darkmode";
//   static const String prefKeyEnableTest = "global.enable.test";
//   static const String prefKeyHaveCompletedWelcome =
//       "global.havecompletedwelcome";
//   static const String prefPanelWeatherShowSummaryKey =
//       "global.havecompletedwelcome";

//   AppSettings([super.values]);

//   bool get testMode => getBool(prefKeyEnableTest) ?? false;
//   bool get darkMode => getBool(prefKeyDarkMode) ?? false;
//   String get languageCode => getString(prefKeyLanguageCode) ?? "en";
//   bool get haveCompletedWelcome =>
//       getBool(prefKeyHaveCompletedWelcome) ?? false;
//   bool get panelWeatherShowSummary =>
//       getBool(prefPanelWeatherShowSummaryKey) ?? false;
//   @override
//   dynamic copyWith(Map<String, dynamic> newValues) {
//     //merge
//     var merged = merge(newValues);
//     return AppSettings(merged);
//   }
// }

abstract class IAppPreference {
  final Map<String, dynamic> values;
  IAppPreference([this.values = const {}]);
  dynamic copyWith(Map<String, dynamic> newValues);
  Map<String, dynamic> merge(Map<String, dynamic> update) {
    if (values.isEmpty) return update;
    var rtn = {...values};
    for (var key in update.keys) {
      rtn.update(
        key,
        (value) => update[key],
        ifAbsent: () => update[key],
      );
    }
    return rtn;
  }

  ///Returns a collecion of preferences that start with the
  ///key provided.  This can be useful fro returning all the preferences for a certain area.
  Map<String, dynamic> getPreferenceSet(String subkey) {
    try {
      var keys = values.keys.where((element) => element.startsWith(subkey));
      Map<String, dynamic> rtn = {};
      for (var key in keys) {
        rtn.putIfAbsent(key, () => values[key]);
      }
      return rtn;
    } catch (e) {
      return {};
    }
  }

  dynamic getValue(String key) {
    return values[key];
  }

  bool? getBool(String key) {
    var v = getValue(key);
    if (v == null) return null;

    try {
      if (v is bool) {
        return v;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String? getString(String key) {
    var v = getValue(key);
    if (v == null) return null;

    try {
      if (v is String) {
        return v;
      }
      return v.toString();
    } catch (e) {
      return null;
    }
  }
}
