import 'dart:convert';

import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_service.g.dart';

class RemoteConfigKeys {
  static const String homeBarTitle = 'homeBarTitle';
  static const String homeBarImageUrl = 'homeBarImageUrl';
  static const String homeBarStyle = 'homeBarStyle';
  static const String mainCategory = 'mainCategory';
  static const String mainColor = 'mainColor';
  static const String mainSettings = 'mainSettings';
}

class RemoteConfigService {
  const RemoteConfigService(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  Future<void> _setConfigSettings() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        // in production mode, minimum 12 horus
        minimumFetchInterval: remoteConfigInterval,
      ),
    );
  }

  Future<void> _setDefaults() async {
    await _remoteConfig.setDefaults(const {
      /*
      RemoteConfigKeys.mainCategory:
          '{"mainCategory":[{"index":0,"path":"/404","title":"Unsorted","color":"FCB126"},]}',
      RemoteConfigKeys.mainColor: 'FCB126',
      RemoteConfigKeys.homeBarTitle: mainAppBarTitle,
      */
      RemoteConfigKeys.mainSettings:
          '{"homeBarTitle":"$spareHomeBarTitle","homeBarImageUrl":"$spareHomeBarImageUrl","homeBarStyle":$spareHomeBarStyle,"mainColor":"$spareMainColor","mainCategory":[{"index":0,"path":"/404","title":"Unsorted","color":"FCB126"}]}'
    });
  }

  Future<void> initialize() async {
    try {
      await _setConfigSettings();
      await _setDefaults();
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Map<String, RemoteConfigValue> getAll() => _remoteConfig.getAll();
  String getString(String key) => _remoteConfig.getString(key);
  bool getBool(String key) => _remoteConfig.getBool(key);
  RemoteConfigValue getValue(String key) => _remoteConfig.getValue(key);
  double getDouble(String key) => _remoteConfig.getDouble(key);
  int getInt(String key) => _remoteConfig.getInt(key);

  Map<String, dynamic> get mainSettings =>
      json.decode(_remoteConfig.getString(RemoteConfigKeys.mainSettings))
          as Map<String, dynamic>;

  List<MainCategory> get mainCategory {
    final catetory = [
      {"index": 0, "path": "/404", "title": "Unsorted", "color": "FCB126"}
    ];
    return (mainSettings[RemoteConfigKeys.mainCategory] as List<dynamic>? ??
            catetory)
        .map((e) => MainCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Color get mainColor => Format.hexStringToColorForCat(
      mainSettings[RemoteConfigKeys.mainColor] as String? ?? spareMainColor);

  String get homeBarTitle =>
      mainSettings[RemoteConfigKeys.homeBarTitle] as String? ??
      spareHomeBarTitle;

  String get homeBarImageUrl =>
      mainSettings[RemoteConfigKeys.homeBarImageUrl] as String? ??
      spareHomeBarImageUrl;

  int get homeBarStyle =>
      mainSettings[RemoteConfigKeys.homeBarStyle] as int? ?? spareHomeBarStyle;

  /*
  List<MainCategory> get mainCategory =>
      ((json.decode(_remoteConfig.getString(RemoteConfigKeys.mainCategory))
              as Map<String, dynamic>)['mainCategory'] as List<dynamic>)
          .map((e) => MainCategory.fromJson(e as Map<String, dynamic>))
          .toList();

  Color get mainColor => Format.hexStringToColorForCat(
      _remoteConfig.getString(RemoteConfigKeys.mainColor));

  String get homeBarTitle =>
      _remoteConfig.getString(RemoteConfigKeys.homeBarTitle);
  */
}

class MainCategory {
  const MainCategory({
    required this.index,
    required this.path,
    required this.title,
    required this.color,
  });

  final int index;
  final String path;
  final String title;
  final Color color;

  factory MainCategory.fromJson(Map<String, dynamic> json) {
    return MainCategory(
      index: json['index'] as int? ?? 0,
      path: json['path'] as String? ?? '/404',
      title: json['title'] as String? ?? 'Unsorted',
      color:
          Format.hexStringToColorForCat(json['color'] as String? ?? 'FCB126'),
    );
  }
}

@Riverpod(keepAlive: true)
RemoteConfigService remoteConfigService(RemoteConfigServiceRef ref) {
  return RemoteConfigService(FirebaseRemoteConfig.instance);
}
