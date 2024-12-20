import 'package:applimode_app/src/utils/regex.dart';
import 'package:flutter/widgets.dart';

class MyCustomColor {
  const MyCustomColor(this.color);

  final Color color;

  int get intR => (color.r * 255).round();
  int get intG => (color.g * 255).round();
  int get intB => (color.b * 255).round();

  static Color hexStringToColor(String hexString) {
    hexString = hexString.toUpperCase().replaceAll("#", "");
    if (hexString.length == 6 && Regex.hexColorRegex.hasMatch(hexString)) {
      hexString = 'FF$hexString';
    } else {
      return const Color(0xFFFCB126);
    }
    final hexInt = int.tryParse(hexString, radix: 16);
    return hexInt == null ? const Color(0xFFFCB126) : Color(hexInt);
  }

  // flutter 3.27 color migration
  String colorToHexString() {
    String hexRed = intR.toRadixString(16).padLeft(2, '0');
    String hexGreen = intG.toRadixString(16).padLeft(2, '0');
    String hexBlue = intB.toRadixString(16).padLeft(2, '0');

    return '$hexRed$hexGreen$hexBlue';
  }

  int colorToIntHex() {
    return (0xFF << 24) | (intR << 16) | (intG << 8) | intB;
  }
}
