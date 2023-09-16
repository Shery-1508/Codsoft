import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  bool isDark = false; // Default theme is light

  ThemeNotifier() {
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
    _saveTheme();
  }

  void _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', isDark);
  }
}
