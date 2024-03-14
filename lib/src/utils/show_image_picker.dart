import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> showImagePicker({
  ImageSource imageSource = ImageSource.gallery,
  bool isMedia = false,
  bool isVideo = false,
  int maxSeconds = videoMaxDuration,
}) async {
  final ImagePicker picker = ImagePicker();
  try {
    final XFile? pickedFile = isMedia
        ? await picker.pickMedia()
        : isVideo
            ? await picker.pickVideo(
                source: imageSource,
                maxDuration: Duration(seconds: maxSeconds),
              )
            : await picker.pickImage(source: imageSource);
    // check file size
    if (pickedFile != null && mediaMaxMBSize != 0.0) {
      final length = await pickedFile.length();
      debugPrint('length: ${length / (1024 * 1024)}');
      final mbSize = length / (1024 * 1024);
      if (mbSize > mediaMaxMBSize) {
        throw FileSizeException();
      }
    }

    return pickedFile;
  } on FileSizeException {
    rethrow;
  } catch (e) {
    debugPrint('image picker error');
    debugPrint(e.toString());
    // Propagate with rethrow
    // rethrow 로 전파시킬 것
    return null;
  }
}
