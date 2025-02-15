import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zerotier_manager/repository/settings_repository.dart';
part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc(this.repository)
      : super(
          SettingsState(
            themeMode: ThemeMode.system,
            language: 'en',
            fontSizeFactor: 1,
            primaryColor: Colors.blue,
          ),
        ) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateThemeModeEvent>(_onUpdateThemeMode);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateFontSizeFactorEvent>(_onUpdateFontSizeFactor);
    on<UpdatePrimaryColorEvent>(_onUpdatePrimaryColor);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final themeMode = await repository.getThemeMode() ?? ThemeMode.system;
    final language = await repository.getLanguage();
    final fontSizeFactor = await repository.getFontSizeFactor() ?? 1;
    final primaryColorValue =
        await repository.getPrimaryColor() ?? Colors.blue.shade500.value;
    emit(
      SettingsState(
        themeMode: themeMode,
        language: language,
        fontSizeFactor: fontSizeFactor,
        primaryColor: Color(primaryColorValue),
      ),
    );
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await repository.setThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await repository.setLanguage(event.language);
    emit(state.copyWith(language: event.language));
  }

  Future<void> _onUpdateFontSizeFactor(
    UpdateFontSizeFactorEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await repository.setFontSizeFactor(event.fontSizeFactor);
    emit(state.copyWith(fontSizeFactor: event.fontSizeFactor));
  }

  Future<void> _onUpdatePrimaryColor(
    UpdatePrimaryColorEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await repository.setPrimaryColor(event.primaryColor.value);
    emit(state.copyWith(primaryColor: event.primaryColor));
  }

  ThemeMode get themeMode => state.themeMode;
  String get language => state.language;
  double get fontSizeFactor => state.fontSizeFactor;
  Color get primaryColor => state.primaryColor;
}
