import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'kb_dark_mode';

  bool _darkMode = false;
  bool get darkMode => _darkMode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> toggle() async {
    _darkMode = !_darkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _darkMode);
    notifyListeners();
  }
}