
class IAppPreference {
  // static bool get isDebug => !isRelease;
  // static bool get isRelease => flavour == "prod";
  // static String get flavour => const String.fromEnvironment('flavour');

  // static late T pref;
}

class AppEnvironment
// <T as IAppPreference> 
{
  static bool get isDebug => !isRelease;
  static bool get isRelease => flavour == "prod";
  static String get flavour => const String.fromEnvironment('flavour');
  

  static IAppPreference preferences = IAppPreference();
}
