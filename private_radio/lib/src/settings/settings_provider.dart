import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _fontName = "Open Sans";

  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _load();
  }

  String get fontName => _fontName;

  // too laggy to use `GoogleFonts.asMap().keys.toList()`
  List<String> get fontNames => [
        "Open Sans",
        "Ballet",
        "Roboto",
        "Montserrat",
        "Poppins",
        "Lato",
        "Inter",
        "Allan",
        "Roboto Mono",
        "Playfair Display",
        "Ubuntu",
        "Wavefont",
      ];

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = switch (prefs.getString('theme')) {
      "ThemeMode.dark" => ThemeMode.dark,
      "ThemeMode.light" => ThemeMode.light,
      _ => ThemeMode.system,
    };
    _fontName = prefs.getString('fontName') ?? "OpenSans";

    notifyListeners();
  }

  Future<void> updateTheme(ThemeMode value) async {
    _themeMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', _themeMode.toString());
  }

  Future<void> updateFontName(String value) async {
    _fontName = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    GoogleFonts.asMap()[_fontName]!();
    prefs.setString('fontName', _fontName);

    if (kDebugMode) {
      print("Selected font ${GoogleFonts.asMap()[_fontName]!()}");
    }
  }
}
