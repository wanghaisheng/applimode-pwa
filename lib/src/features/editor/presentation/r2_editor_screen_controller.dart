import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/r_two_storage/r_two_storage_repository.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/build_remote_media.dart';
import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:applimode_app/src/utils/compare_lists.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/nanoid.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'r2_editor_screen_controller.g.dart';

// UseRTwoStorage
@riverpod
class RTwoEditorScreenController extends _$RTwoEditorScreenController {
// ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() {
      key = null;
    });
  }

  Future<void> publish({
    required String content,
    required int category,
    String? postId,
    Post? post,
    List<String>? oldRemoteMedia,
    required String needLogin,
    required String needPermission,
    required String faildPostSubmit,
    required String initializing,
    required String uploadingFile,
    required String completing,
    AppUser? writer,
    required String postNotiString,
  }) async {
    WakelockPlus.enable();
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      WakelockPlus.disable();
      state = AsyncError(Exception(needLogin), StackTrace.current);
      return;
    }

    // If only the administrator can write, check permissions
    // 관리자만 글쓰기가 가능할 경우, 권한 체크
    if (adminOnlyWrite) {
      final appUser =
          await ref.read(appUserRepositoryProvider).fetchAppUser(user.uid);
      if (appUser == null || !appUser.isAdmin) {
        WakelockPlus.disable();
        state = AsyncError(Exception(needPermission), StackTrace.current);
        return;
      }
    }

    if (postId != null && post == null) {
      // direct access
      // 포스트에서 수정으로 접근이 아닌 바로 접근
      // 팝업창 작성하고 팝
      WakelockPlus.disable();
      state = AsyncError(Exception(needPermission), StackTrace.current);
      return;
    } else if (postId != null && post != null && user.uid != post.uid) {
      // auth user and writer user are different
      // Auth 와 작성자가 다를 경우
      // 팝업창 작성하고 팝
      WakelockPlus.disable();
      state = AsyncError(Exception(needPermission), StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final id = postId ?? nanoid();
    String newContent = content;

    String? mainImageUrl;
    String? mainVideoUrl;
    final List<String> hashtags = [];

    final rTwoRepository = ref.read(rTwoStorageRepositoryProvider);

    final key = this.key;

    try {
      // when updating, media is deleted
      // 업데이트시 미디어가 삭제되었을 경우, 미디어 삭제
      if (postId != null &&
          oldRemoteMedia != null &&
          oldRemoteMedia.isNotEmpty) {
        final newRemoteMedia = buildRemoteMedia(content);
        final deletedMedia = compareLists(oldRemoteMedia, newRemoteMedia);
        for (final mediaUrl in deletedMedia) {
          rTwoRepository.deleteAsset(mediaUrl);
        }
      }

      // media upload
      // 이미지, 비디오 통합 업로드
      final localVideoMatches =
          Regex.localVideoRegex.allMatches(content).toList();
      final localImageMatches =
          Regex.localImageRegex.allMatches(content).toList();

      final userMediaMatches = [...localVideoMatches, ...localImageMatches];

      if (userMediaMatches.isNotEmpty) {
        List<String> localMediaUrls = [];
        List<String> remoteMediaUrls = [];
        for (int i = 0; i < userMediaMatches.length; i++) {
          final match = userMediaMatches[i];
          localMediaUrls.add(match[0]!);
          final filename = nanoid();
          final isVideo = Regex.localVideoRegex.hasMatch(match[0]!);
          String? videoThumbnailUrl = '';

          // media type check
          String? mediaType;
          final mimeType = lookupMimeType(isVideo ? match[2]! : match[1]!);
          if (mimeType != null) {
            mediaType = mimeType;
          } else {
            mediaType = isVideo ? contentTypeMp4 : contentTypeJpeg;
          }

          final needCompress =
              mediaType == contentTypeJpeg || mediaType == contentTypePng;

          // 태그에 따라 bytes로 변경
          final bytes = isVideo
              ? await rTwoRepository.getBytes(XFile(match[2]!))
              : needCompress && !kIsWeb
                  ? await FlutterImageCompress.compressWithFile(match[1]!,
                          quality: 80) ??
                      await rTwoRepository.getBytes(XFile(match[1]!))
                  : await rTwoRepository.getBytes(XFile(match[1]!));

          if (isVideo) {
            if (!kIsWeb) {
              final videoThumbnail = await VideoThumbnail.thumbnailData(
                video: match[2]!,
                imageFormat: ImageFormat.JPEG,
                maxWidth: 1080,
                quality: 100,
              );
              if (videoThumbnail != null) {
                final url = await rTwoRepository.uploadBytes(
                  bytes: videoThumbnail,
                  storagePathname: '/${user.uid}/$postsPath/$id',
                  filename: '$filename-thumbnail',
                  showPercentage: false,
                );
                videoThumbnailUrl = url;
              }
            }
          }

          final remoteMediaUrl = await rTwoRepository.uploadBytes(
            bytes: bytes,
            storagePathname: '/${user.uid}/$postsPath/$id',
            filename: filename,
            contentType: mediaType,
            index: i,
          );

          isVideo
              ? remoteMediaUrls
                  .add('[remoteVideo][$videoThumbnailUrl][$remoteMediaUrl]')
              : remoteMediaUrls.add('[remoteImage][$remoteMediaUrl][]');
        }

        for (int i = 0; i < localMediaUrls.length; i++) {
          newContent =
              newContent.replaceFirst(localMediaUrls[i], remoteMediaUrls[i]);
        }
        debugPrint(newContent);
      }

      // hashtags
      final hashtagMatches = Regex.hashtagRegex.allMatches(newContent);
      if (hashtagMatches.isNotEmpty) {
        for (final tag in hashtagMatches) {
          hashtags.add(tag[1]!);
        }
      }

      // mainImageUrl
      final firstRemoteImage = Regex.remoteImageRegex.firstMatch(newContent);
      final firstWebImage = Regex.webImageRegex.firstMatch(newContent);
      final firstYtImage = Regex.ytRegexB.firstMatch(newContent);
      if (firstRemoteImage != null) {
        mainImageUrl = firstRemoteImage[1];
      } else if (firstWebImage != null) {
        mainImageUrl = firstWebImage[0];
      } else if (firstYtImage != null) {
        mainImageUrl = StringConverter.buildYtThumbnail(firstYtImage[1]!);
      }

      // mainVideoUrl
      final firstRemoteVideo = Regex.remoteVideoRegex.firstMatch(newContent);
      final firstWebVideo = Regex.webVideoRegex.firstMatch(newContent);
      if (firstRemoteVideo != null) {
        mainVideoUrl = firstRemoteVideo[2];
      } else if (firstWebVideo != null) {
        mainVideoUrl = firstWebVideo[0];
      }

      if (postId == null) {
        // new post
        await ref.read(postsRepositoryProvider).createPost(
              id: id,
              uid: user.uid,
              content: newContent,
              category: category,
              mainImageUrl: mainImageUrl,
              mainVideoUrl: mainVideoUrl,
              mainVideoImageUrl: firstRemoteVideo?[1],
              tags: hashtags,
              createdAt: DateTime.now(),
            );
      } else {
        // update post
        await ref.read(postsRepositoryProvider).updatePost(
              id: id,
              // uid: user.uid,
              content: newContent,
              category: category,
              mainImageUrl: mainImageUrl,
              mainVideoUrl: mainVideoUrl,
              mainVideoImageUrl: firstRemoteVideo?[1],
              tags: hashtags,
              updatedAt: DateTime.now(),
            );
      }
    } catch (e, st) {
      WakelockPlus.disable();
      debugPrint('error: $e');
      state = AsyncError(Exception(faildPostSubmit), st);
      return;
    }

    const newState = AsyncData(null);
    if (key == this.key) {
      state = newState;
    }

    if (postId == null && useFcmMessage) {
      try {
        final writerName = writer?.displayName ?? user.displayName;

        callFcmFunction(
            functionName: 'sendFcmMessage',
            content: '${writerName ?? 'Unknown'} $postNotiString',
            isTopic: true,
            topic: 'newPost');
      } catch (e) {
        debugPrint('fcmError: $e');
      }
    }

    WakelockPlus.disable();

    // when success
    // refresh posts list
    // 기존 포스트 리스트 새로고침

    // ref.invalidate(mainPostsListControllerProvider);
    // ref.invalidate(subPostsListControllerProvider);
    // use SimplePageListView
    ref.read(postsListStateProvider.notifier).set(nowToInt());
    // ref.invalidate(mainPostsFutureProvider);
    ref.invalidate(uploadProgressStateProvider);

    if (postId == null) {
      if (ref.read(goRouterProvider).canPop()) {
        ref.read(goRouterProvider).pop();
      }
    } else {
      // refresh post
      // 기존 포스트 새로고침
      ref.invalidate(postFutureProvider);
      if (ref.read(goRouterProvider).canPop()) {
        ref.read(goRouterProvider).pop();
      }
      if (ref.read(goRouterProvider).canPop()) {
        ref.read(goRouterProvider).replace(
              ScreenPaths.post(id),
            );
      }
    }
  }
}
