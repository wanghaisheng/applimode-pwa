import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Format {
  static String hours(double hours) {
    final hoursNotNegative = hours < 0.0 ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  static String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String toAgo(
    BuildContext context,
    DateTime date,
  ) {
    Duration diff = DateTime.now().difference(date);

    if (diff.inDays > 1) {
      return '${diff.inDays}${context.loc.daysAgo}';
    } else if (diff.inDays == 1) {
      return '${diff.inDays}${context.loc.dayAgo}';
    } else if (diff.inHours > 1) {
      return '${diff.inHours}${context.loc.hoursAgo}';
    } else if (diff.inHours == 1) {
      return '${diff.inHours}${context.loc.hourAgo}';
    } else if (diff.inMinutes > 1) {
      return '${diff.inMinutes}${context.loc.minutesAgo}';
    } else if (diff.inMinutes == 1) {
      return '${diff.inMinutes}${context.loc.minuteAgo}';
    } else {
      return context.loc.justNow;
    }
  }

  static String formatNumber(BuildContext context, int number) {
    final systemLanguageCode = Localizations.localeOf(context).languageCode;
    return NumberFormat.compact(locale: systemLanguageCode).format(number);
  }

  static String dateTime(DateTime date) {
    return DateFormat.yMMMEd().add_jm().format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  static String currency(double pay) {
    final payNotNegative = pay <= 0.0 ? 0.0 : pay;
    final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
    return formatter.format(payNotNegative);
  }

  static Color hexStringToColorForCat(String hexString) {
    hexString = hexString.toUpperCase().replaceAll("#", "");
    if (hexString.length == 6 && Regex.hexColorRegex.hasMatch(hexString)) {
      hexString = 'FF$hexString';
    } else {
      return const Color(0xFFFCB126);
    }
    final hexInt = int.tryParse(hexString, radix: 16);
    return hexInt == null ? const Color(0xFFFCB126) : Color(hexInt);
  }

  static String colorToHexString(Color color) {
    return color.value.toRadixString(16).substring(2, 8);
  }

  static String durationToString(Duration duration) {
    return duration.toString().split('.').first.padLeft(8, '0');
  }

  /*
  static int yearMonthToInt(DateTime dateTime) {
    final now = DateTime.now();
    final yearMonthString =
        '${now.year.toString()}${now.month.toString().padLeft(2, '0')}';
    return int.tryParse(yearMonthString) ?? 202311;
  }

  static int yearMonthDayToInt(DateTime dateTime) {
    final now = DateTime.now();
    final yearMonthDayString =
        '${now.year.toString()}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return int.tryParse(yearMonthDayString) ?? 20231106;
  }
  */

  static int yearMonthToInt(DateTime dateTime) {
    final yearMonthString =
        '${dateTime.year.toString()}${dateTime.month.toString().padLeft(2, '0')}';
    return int.tryParse(yearMonthString) ?? 202311;
  }

  static int yearMonthDayToInt(DateTime dateTime) {
    final yearMonthDayString =
        '${dateTime.year.toString()}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}';
    return int.tryParse(yearMonthDayString) ?? 20231106;
  }

  static String getMonthLabel(BuildContext context, int? month) {
    final systemLanguageCode = Localizations.localeOf(context).languageCode;
    return DateFormat('MMM', systemLanguageCode)
        .format(DateTime(2023, month ?? 1));
  }

  static String getDayLabel(
      BuildContext context, int year, int month, int? day) {
    final systemLanguageCode = Localizations.localeOf(context).languageCode;
    return DateFormat('d', systemLanguageCode)
        .format(DateTime(year, month, day ?? 1));
  }

  static List<int> getDaysList(int year, int month) {
    const longMonths = [1, 3, 5, 7, 8, 10, 12];
    if (year % 4 == 0 && month == 2) {
      return List<int>.generate(29, (index) => index + 1);
    }
    if (month == 2) {
      return List<int>.generate(28, (index) => index + 1);
    }
    if (longMonths.contains(month)) {
      return List<int>.generate(31, (index) => index + 1);
    }
    return List<int>.generate(30, (index) => index + 1);
  }

  static String getShortName(String name) {
    if (name.length > usernameMaxLength) {
      return '${name.substring(0, usernameMaxLength)}...';
    }
    return name;
  }

  static String mimeTypeToExt(String mime) {
    switch (mime) {
      case 'image/jpeg':
        return '.jpeg';
      case 'image/gif':
        return '.gif';
      case 'image/png':
        return '.png';
      case 'image/webp':
        return '.wepb';
      case 'video/mp4':
        return '.mp4';
      case 'video/webm':
        return '.webm';
      default:
        return '.jpeg';
    }
  }
}
