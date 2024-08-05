import 'package:applimode_app/src/utils/format.dart';
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
import 'package:mime/mime.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';
import 'package:applimode_app/src/utils/web_video_thumbnail/wvt_stub.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
  }) async {
    WakelockPlus.enable();
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      WakelockPlus.disable();
      state = AsyncError(Exception('Login is required.'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final appUser = await ref.read(appUserFutureProvider(user.uid).future);
    // If only the administrator can write, check permissions
    // 관리자만 글쓰기가 가능할 경우, 권한 체크
    if (adminOnlyWrite) {
      if (appUser == null || !appUser.isAdmin) {
        WakelockPlus.disable();
        state =
            AsyncError(Exception('Permission is required'), StackTrace.current);
        return;
      }
    }

    // If only the verified users can write, check permissions
    // 인증된 사용자만 글쓰기가 가능할 경우, 권한 체크
    if (verifiedOnlyWrite) {
      if (appUser == null || !appUser.verified) {
        WakelockPlus.disable();
        state =
            AsyncError(Exception('Permission is required'), StackTrace.current);
        return;
      }
    }

    if (appUser == null || appUser.isBlock) {
      WakelockPlus.disable();
      state = AsyncError(Exception('you are blocked'), StackTrace.current);
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

    // media type check
    String? mediaType;
    final mimeType = lookupMimeType(isVideo ? match[2]! : match[1]!);
    if (mimeType != null) {
      mediaType = mimeType;
    } else {
      mediaType = isVideo ? contentTypeMp4 : contentTypeJpeg;
    }
    final ext = Format.mimeTypeToExt(mediaType);

    try {
      final bytes = isVideo
          ? await storageRepository.getBytes(XFile(match[2]!))
          : await storageRepository.getBytes(XFile(match[1]!));

      // video thumbnail for mobile
      if (isVideo) {
        String thumbnailFilename = '$filename-thumbnail.jpeg';
        if (kIsWeb) {
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
        } else {
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
        }
      }

      TaskSnapshot? takeSnapshot;

      if (!useRTwoStorage) {
        final uploadTask = storageRepository.uploadTask(
          bytes: bytes,
          storagePathname: '${user.uid}/$postsPath/$id',
          filename: isVideo ? '$filename.mp4' : '$filename$ext',
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
              filename: isVideo ? '$filename.mp4' : '$filename$ext',
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
