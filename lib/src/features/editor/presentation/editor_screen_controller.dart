import 'dart:convert';

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/r_two_storage/r_two_storage_repository.dart';
import 'package:applimode_app/src/features/search/data/d_one_repository.dart';
import 'package:applimode_app/src/utils/build_remote_media.dart';
import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:applimode_app/src/utils/compare_lists.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/nanoid.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:applimode_app/src/utils/upload_progress_state.dart';
import 'package:applimode_app/src/utils/web_video_thumbnail/wvt_stub.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'editor_screen_controller.g.dart';

// useFirebaseStorage
@riverpod
class EditorScreenController extends _$EditorScreenController {
// ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() {
      key = null;
    });
  }

  Future<bool> publish({
    required String content,
    required int category,
    required bool hasPostContent,
    String? postId,
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
      return false;
    }
    final appUser = await ref.read(appUserFutureProvider(user.uid).future);
    // If only the administrator can write, check permissions
    // 관리자만 글쓰기가 가능할 경우, 권한 체크
    if (adminOnlyWrite) {
      if (appUser == null || !appUser.isAdmin) {
        WakelockPlus.disable();
        state = AsyncError(Exception(needPermission), StackTrace.current);
        return false;
      }
    }

    if (appUser == null || appUser.isBlock) {
      WakelockPlus.disable();
      state = AsyncError(Exception(needPermission), StackTrace.current);
      return false;
    }

    if (postId != null && writer == null) {
      WakelockPlus.disable();
      state = AsyncError(Exception(needPermission), StackTrace.current);
      return false;
    }

    if (postId != null &&
        writer != null &&
        user.uid != writer.uid &&
        !appUser.isAdmin) {
      // auth user and writer user are different
      // Auth 와 작성자가 다를 경우
      // 팝업창 작성하고 팝
      WakelockPlus.disable();
      state = AsyncError(Exception(needPermission), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    final id = postId ?? nanoid();
    String newContent = content;

    String? mainImageUrl;
    String? mainVideoUrl;
    final List<String> hashtags = [];

    bool needUpdate = false;

    final storageRepository = ref.read(firebaseStorageRepositoryProvider);
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
          final isFbStorage = mediaUrl.startsWith(storageShortUrl) ||
              mediaUrl.startsWith(firebaseStorageUrlHead) ||
              mediaUrl.startsWith(gcpStorageUrlHead);
          try {
            if (isFbStorage) {
              storageRepository.deleteAsset(mediaUrl);
            } else {
              rTwoRepository.deleteAsset(mediaUrl);
            }
            /*
            if (useRTwoStorage) {
              rTwoRepository.deleteAsset(mediaUrl);
            } else {
              storageRepository.deleteAsset(mediaUrl);
            }
            */
          } catch (e) {
            debugPrint('error: $e');
          }
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
          final ext = Format.mimeTypeToExt(mediaType);

          final needCompress =
              mediaType == contentTypeJpeg || mediaType == contentTypePng;

          // 태그에 따라 bytes로 변경
          final bytes = isVideo
              ? await storageRepository.getBytes(XFile(match[2]!))
              : needCompress && !kIsWeb
                  ? await FlutterImageCompress.compressWithFile(match[1]!,
                          quality: 80) ??
                      await storageRepository.getBytes(XFile(match[1]!))
                  : await storageRepository.getBytes(XFile(match[1]!));

          // generate video thumbnail
          if (isVideo) {
            String thumbnailFilename = '$filename-thumbnail.jpeg';
            if (match[1] != null && match[1]!.isNotEmpty) {
              try {
                final videoThumbnail =
                    await storageRepository.getBytes(XFile(match[1]!));
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
              } catch (e) {
                debugPrint(e.toString());
              }
            } else {
              if (kIsWeb) {
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                  needUpdate = true;
                  thumbnailFilename = '$filename-thumbnail-needupdate.jpeg';
                }
                final videoThumbnail = await WvtStub().getThumbnailData(
                  video: match[2]!,
                  maxWidth: 0,
                  maxHeight: 0,
                  quality: 100,
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
                  maxWidth: 1080,
                  quality: 100,
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
                        (taskSnapshot.bytesTransferred /
                            taskSnapshot.totalBytes);
                    ref
                        .read(uploadProgressStateProvider.notifier)
                        .set(i, percent.toInt());
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
                  index: i,
                )
              : await takeSnapshot?.ref.getDownloadURL() ?? '';

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

      if (postId != null) {
        final remoteVideoMatches =
            Regex.remoteVideoRegex.allMatches(content).toList();
        if (remoteVideoMatches.isNotEmpty) {
          for (final match in remoteVideoMatches) {
            if (match[1] != null &&
                match[1]!.isNotEmpty &&
                (oldRemoteMedia == null ||
                    !oldRemoteMedia.contains(match[1]))) {
              try {
                final videoThumbnail =
                    await storageRepository.getBytes(XFile(match[1]!));
                String thumbnailFilename = '${nanoid()}-thumbnail.jpeg';
                String newUrl = '';
                if (useRTwoStorage) {
                  newUrl = await rTwoRepository.uploadBytes(
                    bytes: videoThumbnail,
                    storagePathname: '${user.uid}/$postsPath/$id',
                    filename: thumbnailFilename,
                    showPercentage: false,
                  );
                } else {
                  newUrl = await storageRepository.uploadBytes(
                    bytes: videoThumbnail,
                    storagePathname: '${user.uid}/$postsPath/$id',
                    filename: thumbnailFilename,
                  );
                }
                newContent = newContent.replaceFirst(match[1]!, newUrl);
              } catch (e) {
                debugPrint(e.toString());
              }
            }
          }
        }
      }

      // hashtags
      final hashtagMatches = Regex.hashtagRegex.allMatches(newContent);
      if (hashtagMatches.isNotEmpty) {
        for (final tag in hashtagMatches) {
          if (tag[1] != null && tag[1]!.trim().isNotEmpty) {
            hashtags.add(tag[1]!.trim());
            if (tag[1]!.contains('_')) {
              if (tag[1]!.replaceAll('_', '').trim().isNotEmpty) {
                hashtags.add(tag[1]!.replaceAll('_', '').trim());
              }
              final splits = tag[1]!.split('_');
              for (final split in splits) {
                if (split.trim().isNotEmpty) {
                  hashtags.add(split.trim());
                }
              }
            }
          }
        }
      }

      if (useDOneForSearch &&
          StringConverter.toSearch(newContent).trim().isNotEmpty) {
        if (postId == null) {
          ref
              .read(dOneRepositoryProvider)
              .postPostsSearch(id, StringConverter.toSearch(newContent));
        } else {
          ref
              .read(dOneRepositoryProvider)
              .putPostsSearch(id, StringConverter.toSearch(newContent));
        }
      }

      // mainImageUrl
      final firstRemoteImage = Regex.remoteImageRegex.firstMatch(newContent);
      final firstWebImage = Regex.webImageRegex.firstMatch(newContent);
      final firstYtImage = Regex.ytRegexB.firstMatch(newContent);
      if (firstRemoteImage != null) {
        mainImageUrl = firstRemoteImage[1];
      } else if (firstWebImage != null) {
        mainImageUrl = firstWebImage[1];
      } else if (firstYtImage != null) {
        mainImageUrl = StringConverter.buildYtThumbnail(firstYtImage[1]!);
      }

      // mainVideoUrl
      final firstRemoteVideo = Regex.remoteVideoRegex.firstMatch(newContent);
      final firstWebVideo = Regex.webVideoRegex.firstMatch(newContent);
      if (firstRemoteVideo != null) {
        mainVideoUrl = firstRemoteVideo[2];
      } else if (firstWebVideo != null) {
        mainVideoUrl = firstWebVideo[2];
      }

      // to shorten cloud storage object url
      newContent = newContent.replaceAll(preStorageUrl, storageShortUrl);
      final postContent = newContent;

      final modifiedNewContent = StringConverter.toTitle(newContent);
      final contentTitle = modifiedNewContent.length > contentTitleSize
          ? modifiedNewContent.substring(0, contentTitleSize)
          : modifiedNewContent;

      final isLongContent = utf8.encode(newContent).length > longContentSize;
      if (isLongContent) {
        newContent = modifiedNewContent.length > contentTitleSize
            ? modifiedNewContent.substring(0, contentTitleSize)
            : modifiedNewContent;
      }

      if (postId == null) {
        // new post
        await ref.read(postsRepositoryProvider).createPost(
              id: id,
              uid: user.uid,
              content: newContent,
              title: contentTitle,
              needUpdate: needUpdate,
              isLongContent: isLongContent,
              category: category,
              mainImageUrl: mainImageUrl,
              mainVideoUrl: mainVideoUrl,
              mainVideoImageUrl: firstRemoteVideo?[1] ?? firstWebVideo?[1],
              tags: hashtags,
              createdAt: DateTime.now(),
            );
      } else {
        // update post
        await ref.read(postsRepositoryProvider).updatePost(
              id: id,
              // uid: user.uid,
              content: newContent,
              title: contentTitle,
              needUpdate: needUpdate,
              isLongContent: isLongContent,
              category: category,
              mainImageUrl: mainImageUrl,
              mainVideoUrl: mainVideoUrl,
              mainVideoImageUrl: firstRemoteVideo?[1] ?? firstWebVideo?[1],
              tags: hashtags,
              updatedAt: DateTime.now(),
            );
      }
      // create postContent
      if (isLongContent) {
        await ref.read(postContentsRepositoryProvider).createPostContent(
              id: id,
              uid: user.uid,
              content: postContent,
              category: category,
            );
      }

      // delete postContent
      try {
        if (!isLongContent && hasPostContent) {
          await ref.read(postContentsRepositoryProvider).deletePostContent(id);
        }
      } catch (e) {
        debugPrint('already deleted');
      }
    } catch (e, st) {
      WakelockPlus.disable();
      debugPrint('error: $e');
      state = AsyncError(Exception(faildPostSubmit), st);
      return false;
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
    if (postId == null) {
      ref.read(postsListStateProvider.notifier).set(nowToInt());
    } else {
      ref.read(updatedPostIdsListProvider.notifier).set(postId);
    }

    // ref.invalidate(mainPostsFutureProvider);
    ref.invalidate(uploadProgressStateProvider);
    ref.invalidate(postContentFutureProvider);

    return true;

    /*
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
    */
  }
}
