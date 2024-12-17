part of 'settings_bloc.dart';

class SettingsState {
  final ThemeMode themeMode;
  final String language;
  final double fontSizeFactor;
  final Color primaryColor;

  SettingsState({
    required this.themeMode,
    required this.language,
    required this.fontSizeFactor,
    required this.primaryColor,
  });

  // Добавим метод copyWith для удобства обновления состояния
  SettingsState copyWith({
    ThemeMode? themeMode,
    String? language,
    double? fontSizeFactor,
    Color? primaryColor,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      fontSizeFactor: fontSizeFactor ?? this.fontSizeFactor,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}
