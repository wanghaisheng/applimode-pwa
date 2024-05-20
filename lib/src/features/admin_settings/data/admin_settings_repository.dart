import 'dart:convert';

import 'package:applimode_app/src/features/admin_settings/domain/admin_settings.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_settings_repository.g.dart';

class AdminSettingsRepository {
  const AdminSettingsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const _adminSettingsPath = 'adminSettings/admin-settings';

  Future<void> createAdminSettings({
    required String homeBarTitle,
    required String homeBarImageUrl,
    required int homeBarStyle,
    required Color mainColor,
    required List<MainCategory> mainCategory,
  }) =>
      _firestore.doc(_adminSettingsPath).set({
        'homeBarTitle': homeBarTitle,
        'homeBarImageUrl': homeBarImageUrl,
        'homeBarStyle': homeBarStyle,
        'mainColor': Format.colorToHexString(mainColor),
        'mainCategory':
            json.encode(mainCategory.map((e) => e.toMap()).toList()),
      });

  DocumentReference<AdminSettings> _docRef() =>
      _firestore.doc(_adminSettingsPath).withConverter(
          fromFirestore: (snapshot, _) =>
              AdminSettings.fromMap(snapshot.data()!),
          toFirestore: (value, _) => value.toMap());

  Future<AdminSettings?> fetchAdminSettings() async {
    final snapshot = await _docRef().get();
    return snapshot.data();
  }

  Stream<AdminSettings?> watchAdminSettings() =>
      _docRef().snapshots().map((event) => event.data());
}

@riverpod
AdminSettingsRepository adminSettingsRepository(
    AdminSettingsRepositoryRef ref) {
  return AdminSettingsRepository(FirebaseFirestore.instance);
}
