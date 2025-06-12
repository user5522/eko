import 'package:eko/extensions/color.dart';
import 'package:flutter/material.dart';

class Settings {
  final bool monetTheming;
  final Color appThemeColor;
  final String preferredUnit;

  Settings({
    this.monetTheming = false,
    this.appThemeColor = Colors.deepPurple,
    this.preferredUnit = '\$',
  });

  Settings copyWith(
          {bool? monetTheming, Color? appThemeColor, String? preferredUnit}) =>
      Settings(
          monetTheming: monetTheming ?? this.monetTheming,
          appThemeColor: appThemeColor ?? this.appThemeColor,
          preferredUnit: preferredUnit ?? this.preferredUnit);

  Map<String, dynamic> toJson() => {
        'monetTheming': monetTheming,
        'appThemeColorValue': appThemeColor.toInt(),
        'preferredUnit': preferredUnit,
      };

  factory Settings.fromJson(Map<String, dynamic> json) {
    final settings = Settings();

    return settings.copyWith(
      preferredUnit: json['preferredUnit'] as String?,
      monetTheming: json['monetTheming'] as bool?,
      appThemeColor: json['appThemeColorValue'] != null
          ? Color(json['appThemeColorValue'] as int)
          : null,
    );
  }
}
