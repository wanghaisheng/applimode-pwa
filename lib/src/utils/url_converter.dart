import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:flutter/foundation.dart';

String getIosWebVideoUrl(String videoUrl) {
  if (kIsWeb &&
      defaultTargetPlatform == TargetPlatform.iOS &&
      !videoUrl.startsWith(firebaseStorageUrlHead) &&
      !videoUrl.startsWith(gcpStorageUrlHead) &&
      !videoUrl.startsWith(rTwoBaseUrl) &&
      !videoUrl.startsWith(cfDomainUrl)) {
    return '$videoUrl#t=0.001';
  } else {
    return videoUrl;
  }
}
