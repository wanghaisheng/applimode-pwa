import 'dart:developer' as dev;
import 'dart:io';

import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/r_two_storage/r_two_storage_repository.dart';
import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/nanoid.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';
import 'package:applimode_app/src/utils/web_video_thumbnail/wvt_stub.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:path/path.dart' as p;

part 'direct_upload_button_controller.g.dart';

@riverpod
class DirectUploadButtonController extends _$DirectUploadButtonController {
// ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<void> upload({
    required String content,
    required String postNotiString,
    required String mediaType,
  }) async {
    WakelockPlus.enable();
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      WakelockPlus.disable();
      state = AsyncError(NeedLogInException(), StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final appUser = await ref.read(appUserFutureProvider(user.uid).future);
    // If only the administrator can write, check permissions
    // 관리자만 글쓰기가 가능할 경우, 권한 체크
    if (adminOnlyWrite) {
      if (appUser == null || !appUser.isAdmin) {
        WakelockPlus.disable();
        state = AsyncError(NeedPermissionException(), StackTrace.current);
        return;
      }
    }

    // If only the verified users can write, check permissions
    // 인증된 사용자만 글쓰기가 가능할 경우, 권한 체크
    if (verifiedOnlyWrite) {
      if (appUser == null || !appUser.verified) {
        WakelockPlus.disable();
        state = AsyncError(NeedPermissionException(), StackTrace.current);
        return;
      }
    }

    if (appUser == null || appUser.isBlock) {
      WakelockPlus.disable();
      state = AsyncError(NeedPermissionException(), StackTrace.current);
      return;
    }

    final key = this.key;

    final id = nanoid();

    final storageRepository = ref.read(firebaseStorageRepositoryProvider);
    final rTwoRepository = ref.read(rTwoStorageRepositoryProvider);

    final filename = nanoid();
    final isVideo = Regex.localVideoRegex.hasMatch(content);
    final match = isVideo
        ? Regex.localVideoRegex.firstMatch(content)!
        : Regex.localImageRegex.firstMatch(content)!;

    String? videoThumbnailUrl = '';

    debugPrint('mediaType: $mediaType');
    final ext = Format.mimeTypeToExtWithDot(mediaType);

    try {
      // Convert media file to bytes
      // 미디어 파일을 bytes로 변경
      Uint8List? bytes;
      try {
        bytes = isVideo
            ? await storageRepository.getBytes(XFile(match[2]!))
            : await storageRepository.getBytes(XFile(match[1]!));
      } catch (e) {
        debugPrint('FailedMediaFileException: $e');
        state = AsyncError(FailedMediaFileException(), StackTrace.current);
        return;
      }

      // When extracting a thumbnail from videos
      // 비디오에서 썸네일 추출할 경우
      if (isVideo) {
        String thumbnailFilename = '$filename-thumbnail.jpeg';
        try {
          if (kIsWeb) {
            // upload thumbnail on web
            final videoThumbnail = await WvtStub().getThumbnailData(
              video: match[2]!,
              maxWidth: videoThumbnailMaxWidth,
              maxHeight: videoThumbnailMaxHeight,
              quality: videoThumbnailQuality,
            );
            // ignore: unnecessary_null_comparison
            if (videoThumbnail != null) {
              if (useRTwoStorage) {
                final url = await rTwoRepository.uploadBytes(
                  bytes: videoThumbnail,
                  storagePathname: '${user.uid}/$postsPath/$id',
                  filename: thumbnailFilename,
                  showPercentage: false,
                );
                videoThumbnailUrl = url;
              } else {
                final url = await storageRepository.uploadBytes(
                  bytes: videoThumbnail,
                  storagePathname: '${user.uid}/$postsPath/$id',
                  filename: thumbnailFilename,
                );
                videoThumbnailUrl = url;
              }
            }
            dev.log('upload thumbnail on web');
          } else {
            // upload thumbnail on native
            final tempDir = await getTemporaryDirectory();
            final destFile = p.join(tempDir.path, thumbnailFilename);
            await FcNativeVideoThumbnail().getVideoThumbnail(
              srcFile: Format.fixMediaWithExt(match[2]!),
              destFile: destFile,
              width: videoThumbnailMaxWidth,
              height: videoThumbnailMaxHeight,
              format: 'jpeg',
              quality: videoThumbnailQuality,
            );
            if (await File(destFile).exists()) {
              final destFileBytes = await File(destFile).readAsBytes();
              if (useRTwoStorage) {
                final url = await rTwoRepository.uploadBytes(
                  bytes: destFileBytes,
                  storagePathname: '${user.uid}/$postsPath/$id',
                  filename: thumbnailFilename,
                  showPercentage: false,
                );
                videoThumbnailUrl = url;
              } else {
                final url = await storageRepository.uploadBytes(
                  bytes: destFileBytes,
                  storagePathname: '${user.uid}/$postsPath/$id',
                  filename: thumbnailFilename,
                );
                videoThumbnailUrl = url;
              }
            } else {
              dev.log('failed to create thumbnail with fc_native');
            }
            /*
            final videoThumbnail = await VideoThumbnail.thumbnailData(
              video: match[2]!,
              imageFormat: ImageFormat.JPEG,
              maxWidth: videoThumbnailMaxWidth,
              maxHeight: videoThumbnailMaxHeight,
              quality: videoThumbnailQuality,
            );
            if (videoThumbnail != null) {
              if (useRTwoStorage) {
                final url = await rTwoRepository.uploadBytes(
                  bytes: videoThumbnail,
                  storagePathname: '${user.uid}/$postsPath/$id',
                  filename: thumbnailFilename,
                  showPercentage: false,
                );
                videoThumbnailUrl = url;
              } else {
                final url = await storageRepository.uploadBytes(
                  bytes: videoThumbnail,
                  storagePathname: '${user.uid}/$postsPath/$id',
                  filename: thumbnailFilename,
                );
                videoThumbnailUrl = url;
              }
            }
            */
          }
        } catch (e) {
          debugPrint('ThumbnailUploadError: ${e.toString()}');
        }
      }

      TaskSnapshot? takeSnapshot;

      if (!useRTwoStorage) {
        final uploadTask = storageRepository.uploadTask(
          bytes: bytes,
          storagePathname: '${user.uid}/$postsPath/$id',
          filename: '$filename$ext',
          contentType: mediaType,
        );

        uploadTask.snapshotEvents.listen(
          (taskSnapshot) {
            switch (taskSnapshot.state) {
              case TaskState.running:
                final percent = 100.0 *
                    (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                ref
                    .read(uploadProgressStateProvider.notifier)
                    .set(0, percent.toInt());
                break;
              case TaskState.error:
                break;
              case TaskState.success:
                break;
              default:
                break;
            }
          },
        );

        takeSnapshot = await uploadTask;
      }

      final remoteMediaUrl = useRTwoStorage
          ? await rTwoRepository.uploadBytes(
              bytes: bytes,
              storagePathname: '${user.uid}/$postsPath/$id',
              filename: '$filename$ext',
              contentType: mediaType,
              index: 0,
            )
          : await takeSnapshot?.ref.getDownloadURL() ?? '';

      /*
      final remoteMediaUrl = useRTwoStorage
          ? await rTwoRepository.uploadBytes(
              bytes: bytes,
              storagePathname: '${user.uid}/$postsPath/$id',
              filename: filename,
              contentType: mediaType,
              index: 0,
            )
          : await storageRepository.uploadBytes(
              bytes: bytes,
              storagePathname: '${user.uid}/$postsPath/$id',
              filename: filename,
              contentType: mediaType,
            );
      */

      final newContent = isVideo
          ? '[remoteVideo][$videoThumbnailUrl][$remoteMediaUrl]'
          : '[remoteImage][$remoteMediaUrl][]';

      final newMatch = isVideo
          ? Regex.remoteVideoRegex.firstMatch(newContent)!
          : Regex.remoteImageRegex.firstMatch(newContent)!;

      final mainImageUrl = newMatch[1];
      final mainVideoUrl = isVideo ? newMatch[2] : null;
      final mainVideoImageUrl = isVideo ? newMatch[1] : null;

      await ref.read(postsRepositoryProvider).createPost(
            id: id,
            uid: user.uid,
            content: newContent,
            title: '',
            mainImageUrl: mainImageUrl,
            mainVideoUrl: mainVideoUrl,
            mainVideoImageUrl: mainVideoImageUrl,
            createdAt: DateTime.now(),
          );
    } catch (e, st) {
      WakelockPlus.disable();
      debugPrint('directUploadError: ${e.toString()}');
      state =
          AsyncError(Exception('Please check your network or media files'), st);
      return;
    }

    if (useFcmMessage) {
      try {
        FcmFunctions.callSendMessage(
            content: '${user.displayName ?? 'Unknown'} $postNotiString',
            isTopic: true,
            topic: 'newPost');
      } catch (e) {
        debugPrint('fcmError: ${e.toString()}');
      }
    }

    WakelockPlus.disable();
    final newState = await AsyncValue.guard(() async {});
    if (key == this.key) {
      state = newState;
    }

    ref.invalidate(uploadProgressStateProvider);
    ref.read(postsListStateProvider.notifier).set(nowToInt());
  }
}
