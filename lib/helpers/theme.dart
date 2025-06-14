import 'package:eko/constants/theme_option.dart';
import 'package:flutter/material.dart';

class ThemeHelper {
  static ColorScheme getColorScheme({
    required bool monetTheming,
    required ThemeOption theme,
    required Brightness systemBrightness,
    required ColorScheme? lightDynamic,
    required ColorScheme? darkDynamic,
    required Color appThemeColor,
  }) {
    if (!(lightDynamic == null || darkDynamic == null) && monetTheming) {
      return getMonetColorScheme(
        theme,
        systemBrightness,
        lightDynamic,
        darkDynamic,
      );
    }

    return getSeedColorScheme(theme, systemBrightness, appThemeColor);
  }

  static ColorScheme getMonetColorScheme(
    ThemeOption theme,
    Brightness systemBrightness,
    ColorScheme lightDynamic,
    ColorScheme darkDynamic,
  ) {
    if (theme == ThemeOption.auto) {
      return systemBrightness == Brightness.light ? lightDynamic : darkDynamic;
    }
    return theme == ThemeOption.light ? lightDynamic : darkDynamic;
  }

  static ColorScheme getSeedColorScheme(
    ThemeOption theme,
    Brightness systemBrightness,
    Color seedColor,
  ) {
    final brightness = theme == ThemeOption.auto
        ? systemBrightness
        : theme == ThemeOption.dark
            ? Brightness.dark
            : Brightness.light;

    return ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
  }
}

extension ThemeExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
}
