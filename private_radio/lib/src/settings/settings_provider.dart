import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = switch (prefs.getString('theme')) {
      "dark" => ThemeMode.dark,
      "light" => ThemeMode.light,
      _ => ThemeMode.system,
    };

    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode = themeMode;
    notifyListeners();

    await prefs.setString('theme', _themeMode.toString());
  }
}
