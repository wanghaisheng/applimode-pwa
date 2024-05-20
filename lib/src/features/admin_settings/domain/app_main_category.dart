import 'package:applimode_app/src/utils/format.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MainCategory extends Equatable {
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

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'path': path,
      'title': title,
      'color': Format.colorToHexString(color),
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        index,
        path,
        title,
        color,
      ];
}
