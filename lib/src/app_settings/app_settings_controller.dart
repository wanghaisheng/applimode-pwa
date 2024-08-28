import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:applimode_app/src/app_settings/app_settings.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';

part 'app_settings_controller.g.dart';

@riverpod
class AppSettingsController extends _$AppSettingsController {
  AppSettingsController();

  @override
  AppSettings build() {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final appThemeMode =
        ThemeMode.values[sharedPreferences.getInt('appThemeMode') ?? 0];
    final appMainColor =
        Color(sharedPreferences.getInt('appColor') ?? Colors.orange.value);
    final appLocaleString = sharedPreferences.getString('appLocale');
    final appLocale = appLocaleString == null ? null : Locale(appLocaleString);
    final appStyle =
        sharedPreferences.getInt('appStyle') ?? sparePostsListType.index;

    return AppSettings(
      appThemeMode: appThemeMode,
      appMainColor: appMainColor,
      appLocale: appLocale,
      appStyle: appStyle,
    );
  }

  Future<void> setAppThemeMode(ThemeMode theme) async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    await sharedPreferences.setInt('appThemeMode', theme.index);
    final appThemeMode =
        ThemeMode.values[sharedPreferences.getInt('appThemeMode') ?? 0];

    state = AppSettings(
      appThemeMode: appThemeMode,
      appMainColor: state.appMainColor,
      appLocale: state.appLocale,
      appStyle: state.appStyle,
    );
  }

  Future<void> setAppColor(Color color) async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    await sharedPreferences.setInt('appColor', color.value);
    final appMainColor =
        Color(sharedPreferences.getInt('appColor') ?? 0xFFFCB126);
    state = AppSettings(
      appThemeMode: state.appThemeMode,
      appMainColor: appMainColor,
      appLocale: state.appLocale,
      appStyle: state.appStyle,
    );
  }

  Future<void> setAppLocale(String languageCode) async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    await sharedPreferences.setString('appLocale', languageCode);
    final appLocaleString = sharedPreferences.getString('appLocale');
    final appLocale = appLocaleString == null ? null : Locale(appLocaleString);
    state = AppSettings(
      appThemeMode: state.appThemeMode,
      appMainColor: state.appMainColor,
      appLocale: appLocale,
      appStyle: state.appStyle,
    );
  }

  Future<void> removeAppLocale() async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    await sharedPreferences.remove('appLocale');
    state = AppSettings(
      appThemeMode: state.appThemeMode,
      appMainColor: state.appMainColor,
      appLocale: null,
      appStyle: state.appStyle,
    );
  }

  Future<void> setAppStyle(PostsListType postsListType) async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    await sharedPreferences.setInt('appStyle', postsListType.index);
    final appStyle =
        sharedPreferences.getInt('appStyle') ?? sparePostsListType.index;

    state = AppSettings(
      appThemeMode: state.appThemeMode,
      appMainColor: state.appMainColor,
      appLocale: state.appLocale,
      appStyle: appStyle,
    );
  }
}
