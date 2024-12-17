// События
part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateThemeModeEvent extends SettingsEvent {
  final ThemeMode themeMode;
  UpdateThemeModeEvent(this.themeMode);
}

class UpdateLanguageEvent extends SettingsEvent {
  final String language;
  UpdateLanguageEvent(this.language);
}

class UpdateFontSizeFactorEvent extends SettingsEvent {
  final double fontSizeFactor;
  UpdateFontSizeFactorEvent(this.fontSizeFactor);
}

class UpdatePrimaryColorEvent extends SettingsEvent {
  final Color primaryColor;
  UpdatePrimaryColorEvent(this.primaryColor);
}
