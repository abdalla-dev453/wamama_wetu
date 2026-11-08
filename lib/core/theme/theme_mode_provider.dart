import 'package:flutter/material.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }

  void toggle() {
    if (_mode == ThemeMode.light) {
      _mode = ThemeMode.dark;
    } else if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.system;
    } else {
      _mode = ThemeMode.light;
    }
    notifyListeners();
  }
}