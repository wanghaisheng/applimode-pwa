import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    this.appThemeMode,
    this.appLocale,
    this.appStyle,
  });

  final ThemeMode? appThemeMode;
  final Locale? appLocale;
  final int? appStyle;
}
