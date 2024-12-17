import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final SharedPreferences _sharedPreferences;

  SettingsRepository(this._sharedPreferences);

  // Фабричный асинхронный конструктор
  static Future<SettingsRepository> create() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return SettingsRepository(sharedPreferences);
  }

  Future<String> getLanguage() async {
    return _sharedPreferences.getString('language') ?? 'en';
  }

  Future<void> setLanguage(String value) async {
    await _sharedPreferences.setString('language', value);
  }

  // Dynamic Theme color
  Future<void> setPrimaryColor(int colorValue) async {
    await _sharedPreferences.setInt('primaryColor', colorValue);
  }

  Future<int?> getPrimaryColor() async {
    return _sharedPreferences.getInt('primaryColor');
  }

  // Font size
  Future<double?> getFontSize() async {
    return _sharedPreferences.getDouble('fontSize');
  }

  Future<void> setFontSize(double size) async {
    await _sharedPreferences.setDouble('fontSize', size);
  }

  // Theme mode
  Future<ThemeMode?> getThemeMode() async {
    final modeString = _sharedPreferences.getString('themeMode');
    if (modeString != null) {
      return ThemeMode.values.firstWhere((e) => e.toString() == modeString);
    }
    return null;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _sharedPreferences.setString('themeMode', mode.toString());
  }

  // Font size factor
  Future<double?> getFontSizeFactor() async {
    return _sharedPreferences.getDouble('fontSizeFactor');
  }

  Future<void> setFontSizeFactor(double factor) async {
    await _sharedPreferences.setDouble('fontSizeFactor', factor);
  }
}
