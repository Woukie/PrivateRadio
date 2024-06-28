import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late final SharedPreferences prefs;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    prefs = await SharedPreferences.getInstance();

    _themeMode = switch (prefs.getString('theme')) {
      "dark" => ThemeMode.dark,
      "light" => ThemeMode.light,
      _ => ThemeMode.system,
    };

    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await prefs.setString('theme', _themeMode.toString());

    notifyListeners();
  }
}
