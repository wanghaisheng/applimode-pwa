import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/r_two_storage/r_two_storage_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_account_service.g.dart';

class DeleteAccountService {
  const DeleteAccountService(this._ref);

  final Ref _ref;

  Future<void> deleteAccount({
    required String uid,
  }) async {
    // delete posts
    final postIds =
        await _ref.read(postsRepositoryProvider).getPostIdsForUser(uid);
    for (var postId in postIds) {
      await _ref.read(postsRepositoryProvider).deletePost(postId);
    }

    // delete postContents
    final postContentIds = await _ref
        .read(postContentsRepositoryProvider)
        .getPostContentIdsForUser(uid);
    for (var postContentId in postContentIds) {
      await _ref
          .read(postContentsRepositoryProvider)
          .deletePostContent(postContentId);
    }

    // delete post assets
    final storage = _ref.read(firebaseStorageRepositoryProvider);
    final postsRef = storage.storageRef('$uid/posts');
    final postsList = await postsRef.listAll();
    for (var prefix in postsList.prefixes) {
      final postRef = storage.storageRef(prefix.fullPath);
      final itemsList = await postRef.listAll();
      for (var item in itemsList.items) {
        await item.delete();
      }
    }

    if (useRTwoStorage) {
      try {
        await _ref.read(rTwoStorageRepositoryProvider).deleteAssetsList(uid);
      } catch (e) {
        debugPrint('already delete');
      }
    }

    // delete postComments and postCommentImages
    final postComments = await _ref
        .read(postCommentsRepositoryProvider)
        .getPostCommentsForUser(uid);
    for (var postComment in postComments) {
      if (postComment.imageUrl != null) {
        await _ref
            .read(firebaseStorageRepositoryProvider)
            .deleteAsset(postComment.imageUrl!);
      }
      await _ref
          .read(postCommentsRepositoryProvider)
          .deletePostComment(postComment.id);
    }

    // delete postLikes
    final postLikeIds =
        await _ref.read(postLikesRepositoryProvider).getPostLikeIdsForUser(uid);
    for (var postLikeId in postLikeIds) {
      await _ref.read(postLikesRepositoryProvider).deletePostLike(postLikeId);
    }

    // delete postCommentLikes
    final postCommentLikeIds = await _ref
        .read(postCommentLikesRepositoryProvider)
        .getPostCommentLikeIdsForUser(uid);
    for (var postCommentLikeId in postCommentLikeIds) {
      await _ref
          .read(postCommentLikesRepositoryProvider)
          .deletePostCommentLike(postCommentLikeId);
    }

    // delete app user and assets
    final appUser = await _ref.read(appUserFutureProvider(uid).future);
    if (appUser != null) {
      if (appUser.photoUrl != null) {
        await _ref
            .read(firebaseStorageRepositoryProvider)
            .deleteAsset(appUser.photoUrl!);
      }
      if (appUser.storyUrl != null) {
        await _ref
            .read(firebaseStorageRepositoryProvider)
            .deleteAsset(appUser.storyUrl!);
      }
      await _ref.read(appUserRepositoryProvider).deleteAppUser(uid);
    }

    // delete auth user
    await _ref.read(authRepositoryProvider).currentUser!.delete();
  }
}

@riverpod
DeleteAccountService deleteAccountService(DeleteAccountServiceRef ref) {
  return DeleteAccountService(ref);
}
