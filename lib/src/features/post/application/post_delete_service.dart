import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_contents_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
// ignore: unused_import
import 'package:applimode_app/src/features/r_two_storage/r_two_storage_repository.dart';
import 'package:applimode_app/src/features/search/data/d_one_repository.dart';
import 'package:applimode_app/src/utils/delete_storage_list.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDeleteService {
  const PostDeleteService(this.ref);

  final Ref ref;

  Future<void> deletePost({
    required String uid,
    required String postId,
    required bool isLongContent,
  }) async {
    // delete comment likes
    final commentLikeIds = await ref
        .read(postCommentLikesRepositoryProvider)
        .getPostCommentLikeIdsForPost(postId);
    for (var commentLikeId in commentLikeIds) {
      await ref
          .read(postCommentLikesRepositoryProvider)
          .deletePostCommentLike(commentLikeId);
    }

    // delete post comments
    final commentIds = await ref
        .read(postCommentsRepositoryProvider)
        .getPostCommentIdsForPost(postId);
    for (var commentId in commentIds) {
      await ref
          .read(postCommentsRepositoryProvider)
          .deletePostComment(commentId);
    }

    // delete post likes
    final postLikeIds = await ref
        .read(postLikesRepositoryProvider)
        .getPostLikeIdsForPost(postId);

    for (var postLikeId in postLikeIds) {
      await ref.read(postLikesRepositoryProvider).deletePostLike(postLikeId);
    }

    // delete comment medias
    try {
      await deleteStorageList(ref, '$commentsPath/$postId');
    } catch (e) {
      debugPrint('already delete');
      debugPrint('deleteStorageList: ${e.toString()}');
    }

    // delete post medias
    // for firebase storage
    try {
      await deleteStorageList(ref, '$uid/$postsPath/$postId');
    } catch (e) {
      debugPrint('already delete');
      debugPrint('deleteStorageList: ${e.toString()}');
    }
    // useFirebaseStorage
    if (useRTwoStorage) {
      try {
        await ref
            .read(rTwoStorageRepositoryProvider)
            .deleteAssetsList('$uid/$postsPath/$postId');
      } catch (e) {
        debugPrint('already delete');
        debugPrint('deleteAssetsList: ${e.toString()}');
      }
    }

    // delete d1 search index
    if (useDOneForSearch) {
      try {
        ref.read(dOneRepositoryProvider).deletePostsSearch(postId);
      } catch (e) {
        debugPrint('already delete');
        debugPrint('deletePostsSearch: ${e.toString()}');
      }
    }

    // delete postContent
    if (isLongContent) {
      try {
        await ref
            .read(postContentsRepositoryProvider)
            .deletePostContent(postId);
      } catch (e) {
        debugPrint('already delete');
        debugPrint('deletePostContent: ${e.toString()}');
      }
    }

    // delete post
    await ref.read(postsRepositoryProvider).deletePost(postId);
  }
}
