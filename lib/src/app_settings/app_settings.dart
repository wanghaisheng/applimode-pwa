import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    this.appThemeMode,
    this.appMainColor,
    this.appLocale,
    this.appStyle,
  });

  final ThemeMode? appThemeMode;
  final Color? appMainColor;
  final Locale? appLocale;
  final int? appStyle;
}
