import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FormFactor {
  static double desktop = 900;
  static double tablet = 600;
  static double handset = 300;
}

enum ScreenSize { small, normal, large, extraLarge }

enum ScreenType { watch, handset, tablet, desktop }

class ContextualUtil {

  
  static ScreenType getFormFactor(BuildContext context) {
    // Use .shortestSide to detect device type regardless of orientation
    double deviceWidth = MediaQuery.of(context).size.shortestSide;

    if (MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height) {
      return ScreenType.handset;
    }

    if (deviceWidth > FormFactor.desktop) return ScreenType.desktop;
    if (deviceWidth > FormFactor.tablet) return ScreenType.tablet;
    if (deviceWidth > FormFactor.handset) return ScreenType.handset;
    return ScreenType.watch;
  }

  static ScreenSize getSize(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.shortestSide;
    if (deviceWidth > 900) return ScreenSize.extraLarge;
    if (deviceWidth > 600) return ScreenSize.large;
    if (deviceWidth > 300) return ScreenSize.normal;
    return ScreenSize.small;
  }

  static bool get isMobileDevice =>
      !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  static bool get isDesktopDevice =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
  static bool get isMobileDeviceOrWeb => kIsWeb || isMobileDevice;
  static bool get isDesktopDeviceOrWeb => kIsWeb || isDesktopDevice;

  static bool get isWindows => (Platform.isWindows);

  static bool isHandset(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static getEdgePage(BuildContext context) => const EdgeInsets.all(15);
}

class Insets {
  static const double xsmall = 3;
  static const double small = 4;
  static const double medium = 5;
  static const double large = 10;
  static const double extraLarge = 20;
  // etc
}

class Fonts {
  static const String raleway = 'Raleway';
  // etc
}

class TextStyles {
  static const TextStyle raleway = TextStyle(
    fontFamily: Fonts.raleway,
  );
  static TextStyle buttonText1 =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  static TextStyle buttonText2 =
      const TextStyle(fontWeight: FontWeight.normal, fontSize: 11);
  static TextStyle h1 =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 22);
  static TextStyle h2 =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  static TextStyle body1 = raleway.copyWith(color: const Color(0xFF42A5F5));
  // etc
}
