import 'dart:convert';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/data/admin_settings_repository.dart';
import 'package:applimode_app/src/features/admin_settings/domain/admin_settings.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_settings_service.g.dart';

class AdminSettingsService {
  const AdminSettingsService(this._ref);

  final Ref _ref;

  SharedPreferences get sharedPreferences =>
      _ref.read(sharedPreferencesProvider);
  AdminSettingsRepository get adminSettingsRepository =>
      _ref.read(adminSettingsRepositoryProvider);

  Future<void> saveAdminSettings({
    required String homeBarTitle,
    required int homeBarStyle,
    required Color mainColor,
    required List<MainCategory> mainCategory,
    XFile? xFile,
  }) async {
    String homeBarImageUrl = spareHomeBarImageUrl;
    if (xFile != null) {
      homeBarImageUrl =
          await _ref.read(firebaseStorageRepositoryProvider).uploadXFile(
                file: xFile,
                storagePathname: appBarTitlePath,
                filename: 'app-bar-logo',
              );
    }
    await _ref.read(adminSettingsRepositoryProvider).createAdminSettings(
          homeBarTitle: homeBarTitle,
          homeBarImageUrl: homeBarImageUrl,
          homeBarStyle: homeBarStyle,
          mainColor: mainColor,
          mainCategory: mainCategory,
        );
  }

  Future<void> initialize() async {
    // debugPrint('adminSettings init starts : ${DateTime.now()}');
    final lastModified =
        sharedPreferences.getInt(adminSettingsModifiedTimeKey) ?? 0;
    final durationInSeconds = Duration(
            milliseconds: DateTime.now().millisecondsSinceEpoch - lastModified)
        .inSeconds;
    debugPrint('duration: $durationInSeconds');
    if (durationInSeconds > adminSettingsInterval.inSeconds) {
      fetch();
    } else {
      debugPrint('adminSettings timelimit');
    }
    // debugPrint('adminSettings init ends : ${DateTime.now()}');
  }

  Future<void> fetch() async {
    try {
      // debugPrint('adminSettings fetch starts : ${DateTime.now()}');
      final adminSettings = await adminSettingsRepository.fetchAdminSettings();
      // debugPrint('adminSettings: $adminSettings');
      // debugPrint('adminSettings update starts : ${DateTime.now()}');
      if (adminSettings != null) {
        final deviceAdminSettings = _ref.read(adminSettingsProvider);

        if (adminSettings != deviceAdminSettings) {
          debugPrint('admin settings update');
          sharedPreferences.setString(
              homeBarTitleKey, adminSettings.homeBarTitle);
          sharedPreferences.setString(
              homeBarImageUrlKey, adminSettings.homeBarImageUrl);
          sharedPreferences.setInt(homeBarStyleKey, adminSettings.homeBarStyle);
          sharedPreferences.setString(
              mainColorKey, Format.colorToHexString(adminSettings.mainColor));
          sharedPreferences.setString(
              mainCategoryKey,
              json.encode(
                  adminSettings.mainCategory.map((e) => e.toMap()).toList()));
          sharedPreferences.setInt(adminSettingsModifiedTimeKey,
              DateTime.now().millisecondsSinceEpoch);
        } else {
          debugPrint('admin setting same');
          sharedPreferences.setInt(adminSettingsModifiedTimeKey,
              DateTime.now().millisecondsSinceEpoch);
        }
      }
      // debugPrint('adminSettings update ends : ${DateTime.now()}');
    } catch (e) {
      debugPrint('Failed to fetch adminSettings');
    }
  }

  /*
  Color get mainColor => Format.hexStringToColorForCat(
      sharedPreferences.getString(mainColorKey) ?? spareMainColor);

  String get homeBarTitle =>
      sharedPreferences.getString(homeBarTitleKey) ?? spareHomeBarTitle;

  String get homeBarImageUrl =>
      sharedPreferences.getString(homeBarImageUrlKey) ?? spareHomeBarImageUrl;

  int get homeBarStyle =>
      sharedPreferences.getInt(homeBarStyleKey) ?? spareHomeBarStyle;

  List<MainCategory> get mainCategory {
    final rawCategory =
        sharedPreferences.getString(mainCategoryKey) ?? spareMainCategory;
    final decoded = json.decode(rawCategory) as List<dynamic>;
    return decoded
        .map((e) => MainCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  */
}

@riverpod
AdminSettingsService adminSettingsService(AdminSettingsServiceRef ref) {
  return AdminSettingsService(ref);
}

@riverpod
AdminSettings adminSettings(AdminSettingsRef ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return AdminSettings(
    homeBarTitle:
        sharedPreferences.getString(homeBarTitleKey) ?? spareHomeBarTitle,
    homeBarImageUrl:
        sharedPreferences.getString(homeBarImageUrlKey) ?? spareHomeBarImageUrl,
    homeBarStyle:
        sharedPreferences.getInt(homeBarStyleKey) ?? spareHomeBarStyle,
    mainColor: Format.hexStringToColorForCat(
        sharedPreferences.getString(mainColorKey) ?? spareMainColor),
    mainCategory: (json.decode(sharedPreferences.getString(mainCategoryKey) ??
            spareMainCategory) as List<dynamic>)
        .map((e) => MainCategory.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
