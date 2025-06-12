import 'dart:convert';

import 'package:eko/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings()) {
    loadSettings();
  }

  void updateAppThemeColor(Color appThemeColor) {
    final newState = state.copyWith(
      appThemeColor: appThemeColor,
    );
    state = newState;
    saveSettings();
  }

  void updatePreferredUnit(String preferredUnit) {
    final newState = state.copyWith(
      preferredUnit: preferredUnit,
    );
    state = newState;
    saveSettings();
  }

  void updateMonetThemeing(bool monetTheming) {
    final newState = state.copyWith(
      monetTheming: monetTheming,
    );
    state = newState;
    saveSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final settingsJson = prefs.getString('settings');

    if (settingsJson == null) return;

    final settingsMap = jsonDecode(settingsJson);

    final loadedSettings = Settings.fromJson(settingsMap);
    state = loadedSettings;
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = state.toJson();

    await prefs.setString('settings', jsonEncode(settingsJson));
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);
