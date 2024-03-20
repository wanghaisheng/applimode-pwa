import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';

String? getFsUrl(String? shortUrl) =>
    shortUrl?.replaceAll(storageShortUrl, preStorageUrl);
