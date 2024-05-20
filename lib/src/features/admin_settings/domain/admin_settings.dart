import 'dart:convert';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class AdminSettings extends Equatable {
  const AdminSettings({
    required this.homeBarTitle,
    required this.homeBarImageUrl,
    required this.homeBarStyle,
    required this.mainColor,
    required this.mainCategory,
  });

  final String homeBarTitle;
  final String homeBarImageUrl;
  final int homeBarStyle;
  final Color mainColor;
  final List<MainCategory> mainCategory;

  factory AdminSettings.fromMap(Map<String, dynamic> map) {
    return AdminSettings(
      homeBarTitle: map[homeBarTitleKey] as String? ?? spareHomeBarTitle,
      homeBarImageUrl:
          map[homeBarImageUrlKey] as String? ?? spareHomeBarImageUrl,
      homeBarStyle: map[homeBarStyleKey] as int? ?? spareHomeBarStyle,
      mainColor: Format.hexStringToColorForCat(
          map[mainColorKey] as String? ?? spareMainColor),
      mainCategory:
          (json.decode((map[mainCategoryKey] as String?) ?? spareMainCategory)
                  as List<dynamic>)
              .map((e) => MainCategory.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'homeBarTitle': homeBarTitle,
      'homeBarImageUrl': homeBarImageUrl,
      'homeBarStyle': homeBarStyle,
      'mainColor': Format.colorToHexString(mainColor),
      'mainCategory': json.encode(mainCategory.map((e) => e.toMap()).toList()),
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        homeBarTitle,
        homeBarImageUrl,
        homeBarStyle,
        mainColor,
        mainCategory,
      ];
}
