import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_floating_action_button/direct_upload_button_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/show_adaptive_alert_dialog.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class DirectUploadButton extends ConsumerWidget {
  const DirectUploadButton({
    super.key,
    this.heroTag,
  });

  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// To hide the direct upload button if the user is not logged in
    /// 사용자가 로그인하지 않을 경우 다이렉트 업로드 버튼 숨기기위해
    final user = ref.watch(authStateChangesProvider).value;

    /// Added an appUser patch for cases where only administrators or authorized users are allowed to post
    /// To minimize database connections, data is fetched only when conditions are met
    /// 관리자 또는 인증된 사용자만 글을 쓸 수 있을 경우를 위해 appUser 패치
    /// 데이터베이스 연결을 최소화하기 위해 조건이 있을 경우에만 데이터 패치
    final appUser =
        (user != null && adminOnlyWrite) || (user != null && verifiedOnlyWrite)
            ? ref.watch(appUserFutureProvider(user.uid)).value
            : null;

    /// Get the maximum file size specified by the administrator
    /// 관리자가 지정한 파일 최대 크기 가져오기
    final mediaMaxMBSize = ref.watch(adminSettingsProvider).mediaMaxMBSize;

    return (user != null && !adminOnlyWrite && !verifiedOnlyWrite) ||
            (adminOnlyWrite && appUser != null && appUser.isAdmin) ||
            (verifiedOnlyWrite && appUser != null && appUser.verified)
        ? FloatingActionButton.small(
            heroTag: heroTag,
            shape: const CircleBorder(),
            onPressed: () async {
              final XFile? pickedFile = await showImagePicker(
                maxWidth: postImageMaxWidth,
                imageQuality: postImageQuality,
                mediaMaxMBSize: mediaMaxMBSize,
              ).catchError((error) {
                if (context.mounted) {
                  showAdaptiveAlertDialog(
                      context: context,
                      title: context.loc.maxFileSizeErrorTitle,
                      content:
                          '${context.loc.maxFileSizedErrorContent} (${mediaMaxMBSize}MB)');
                }
                return null;
              });
              if (pickedFile != null) {
                bool isVideo = false;
                String? mediaType = pickedFile.mimeType;

                debugPrint('mt: $mediaType');

                if (mediaType == null) {
                  final fileExt = pickedFile.name.split('.').last.toLowerCase();
                  debugPrint('ext: $fileExt');
                  debugPrint('is this video: ${videoExts.contains(fileExt)}');
                  if (videoExts.contains(fileExt)) {
                    mediaType = Format.extToMimeType(fileExt);
                    isVideo = true;
                  } else if (imageExts.contains(fileExt)) {
                    mediaType = Format.extToMimeType(fileExt);
                    isVideo = false;
                  } else {
                    debugPrint('ext is unsupported mediaType');
                    return;
                  }
                } else {
                  if (imageContentTypes.contains(mediaType)) {
                    isVideo = false;
                  } else if (videoConetntTypes.contains(mediaType)) {
                    isVideo = true;
                  } else {
                    debugPrint('mediaType is unsupported mediaType');
                    return;
                  }
                }

                final content = isVideo
                    ? '[localVideo][][${pickedFile.path}]'
                    : '[localImage][${pickedFile.path}][]';
                ref.read(directUploadButtonControllerProvider.notifier).upload(
                      content: content,
                      // ignore: use_build_context_synchronously
                      postNotiString: context.loc.postNoti,
                      mediaType: mediaType,
                    );
              }
            },
            child: const Icon(Icons.arrow_upward),
          )
        : const SizedBox.shrink();
  }
}
