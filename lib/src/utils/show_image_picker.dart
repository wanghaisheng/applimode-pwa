import 'dart:developer' as dev;

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> showImagePicker({
  ImageSource imageSource = ImageSource.gallery,
  bool isImage = false,
  int maxSeconds = videoMaxDuration,
  double? maxWidth,
  double? maxHeight,
  int? imageQuality,
  required double mediaMaxMBSize,
}) async {
  final ImagePicker picker = ImagePicker();
  try {
    final XFile? pickedFile = isImage
        ? await picker.pickImage(
            source: imageSource,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
          )
        : await picker.pickMedia(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
          );
    // check file size
    if (pickedFile != null && mediaMaxMBSize != 0.0) {
      final length = await pickedFile.length();
      final mbSize = length / (1024 * 1024);
      dev.log('media size: $mbSize');
      if (mbSize > mediaMaxMBSize) {
        throw FileSizeException();
      }
    }

    return pickedFile;
  } on FileSizeException {
    rethrow;
  } catch (e) {
    debugPrint('imagePickerError: ${e.toString()}');
    // Propagate with rethrow
    // rethrow 로 전파시킬 것
    return null;
  }
}
