import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Optionally, load initial theme from preferences
  // void loadTheme() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _themeMode = prefs.getBool('isDarkMode') ?? false ? ThemeMode.dark : ThemeMode.light;
  //   notifyListeners();
  // }
}
