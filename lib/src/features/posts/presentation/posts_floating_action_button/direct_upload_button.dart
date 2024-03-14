import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/direct_upload_button_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class DirectUploadButton extends ConsumerWidget {
  const DirectUploadButton({
    super.key,
    this.heroTag,
  });

  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.small(
      heroTag: heroTag,
      shape: const CircleBorder(),
      onPressed: () async {
        final XFile? pickedFile = await showImagePicker(
          isMedia: true,
        ).catchError((error) {
          showAdaptiveAlertDialog(
              context: context,
              title: context.loc.maxFileSizeErrorTitle,
              content:
                  '${context.loc.maxFileSizedErrorContent} (${mediaMaxMBSize}MB)');
          return null;
        });
        if (pickedFile != null) {
          bool? isVideo;
          final mediaType = lookupMimeType(pickedFile.path);
          if (mediaType == null) {
            isVideo = false;
          } else {
            isVideo = mediaType == contentTypeMp4;
          }
          final content = isVideo
              ? '[localVideo][][${pickedFile.path}]'
              : '[localImage][${pickedFile.path}][]';
          ref.read(directUploadButtonControllerProvider.notifier).upload(
                content: content,
                // ignore: use_build_context_synchronously
                postNotiString: context.loc.postNoti,
              );
        }
      },
      child: const Icon(Icons.arrow_upward),
    );
  }
}
