import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final Locale locale;
  final ThemeMode themeMode;

  const AppSettings({
    required this.locale,
    required this.themeMode,
  });

  AppSettings copyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class AppSettingsController extends StateNotifier<AppSettings> {
  AppSettingsController()
      : super(const AppSettings(
          locale: Locale('en', ''),
          themeMode: ThemeMode.system,
        ));

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }

  void toggleLanguage() {
    final newLocale = state.locale.languageCode == 'en'
        ? const Locale('hi', '')
        : const Locale('en', '');
    state = state.copyWith(locale: newLocale);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }
}

final appSettingsControllerProvider =
    StateNotifierProvider<AppSettingsController, AppSettings>((ref) {
  return AppSettingsController();
});
