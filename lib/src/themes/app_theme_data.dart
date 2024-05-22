import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData themeData({
    Color? colorSchemeSeed,
    Brightness? brightness,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorSchemeSeed: colorSchemeSeed,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        // elevation: 10,
        // toolbarHeight: 80,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          //shape: CircleBorder(),
          ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.all(24)),
      )),
      filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.all(24)),
      )),
      textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.all(24)),
      )),
      outlinedButtonTheme: const OutlinedButtonThemeData(
          style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.all(24)),
      )),
    );
  }
}
