import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/firebase_storage/firebase_storage_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/utils/nanoid.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PostCommentsService {
  const PostCommentsService(this.ref);

  final Ref ref;

  Future<void> leavePostComment({
    required String id,
    required String uid,
    required String postId,
    required String parentCommentId,
    required String postWriterId,
    required bool isReply,
    String? content,
    XFile? xFile,
  }) async {
    await ref
        .read(postsRepositoryProvider)
        .updatePostCommentCount(id: postId, number: 1);

    if (isReply) {
      await ref
          .read(postCommentsRepositoryProvider)
          .updateReplyCount(id: parentCommentId, number: 1);
    }

    String? remoteImageUrl;
    if (xFile != null) {
      remoteImageUrl =
          await ref.read(firebaseStorageRepositoryProvider).uploadXFile(
                file: xFile,
                storagePathname: '$commentsPath/$postId',
                filename: nanoid(),
              );
    }

    await ref.read(postCommentsRepositoryProvider).createPostComment(
          id: id,
          uid: uid,
          postId: postId,
          parentCommentId: parentCommentId,
          postWriterId: postWriterId,
          isReply: isReply,
          content: content,
          imageUrl: remoteImageUrl,
        );
  }

  Future<void> deletePostComment({
    required String id,
    required String postId,
    required String parentCommentId,
    bool isReply = false,
    String? imageUrl,
  }) async {
    // it's too many reading, so considering
    // delete image
    if (imageUrl != null) {
      ref.read(firebaseStorageRepositoryProvider).deleteAsset(imageUrl);
    }
    // delete replies
    if (!isReply) {
      final replies = await ref
          .read(postCommentsRepositoryProvider)
          .getPostCommentRepliesForComment(id);
      for (final reply in replies) {
        if (reply.imageUrl != null) {
          ref
              .read(firebaseStorageRepositoryProvider)
              .deleteAsset(reply.imageUrl!);
        }
        /*
        final likeIds = await ref
            .read(postCommentLikesRepositoryProvider)
            .getPostCommentLikeIdsForComment(reply.id);
        for (final likeId in likeIds) {
          await ref
              .read(postCommentLikesRepositoryProvider)
              .deletePostCommentLike(likeId);
        }
        */
        await ref
            .read(postCommentsRepositoryProvider)
            .deletePostComment(reply.id);
      }
      try {
        await ref
            .read(postsRepositoryProvider)
            .updatePostCommentCount(id: postId, number: -replies.length - 1);
      } catch (e) {
        debugPrint('this post has already deleted');
      }
    }
    // delete comment likes
    final likeIds = isReply
        ? await ref
            .read(postCommentLikesRepositoryProvider)
            .getPostCommentLikeIdsForComment(id)
        : await ref
            .read(postCommentLikesRepositoryProvider)
            .getPostParentCommentLikeIdsForComment(parentCommentId);
    for (final likeId in likeIds) {
      await ref
          .read(postCommentLikesRepositoryProvider)
          .deletePostCommentLike(likeId);
    }
    await ref.read(postCommentsRepositoryProvider).deletePostComment(id);

    if (isReply) {
      try {
        await ref
            .read(postCommentsRepositoryProvider)
            .updateReplyCount(id: parentCommentId, number: -1);
        await ref
            .read(postsRepositoryProvider)
            .updatePostCommentCount(id: postId, number: -1);
      } catch (e) {
        debugPrint('already deleted');
      }
    }
  }

  Future<void> increasePostCommentLike({
    required String id,
    required String uid,
    required String postId,
    required String commentId,
    required String commentWriterId,
    required String postWriterId,
    required String parentCommentId,
  }) async {
    await ref.read(postCommentsRepositoryProvider).increaseLikeCount(commentId);
    await ref
        .read(appUserRepositoryProvider)
        .increaseLikeCount(commentWriterId);
    await ref.read(postCommentLikesRepositoryProvider).createPostCommentLike(
          id: id,
          uid: uid,
          postId: postId,
          commentId: commentId,
          commentWriterId: commentWriterId,
          postWriterId: postWriterId,
          parentCommentId: parentCommentId,
          createdAt: DateTime.now(),
        );
  }

  Future<void> decreasePostCommentLike({
    required String id,
    required String commentId,
    required String commentWriterId,
  }) async {
    await ref.read(postCommentsRepositoryProvider).decreaseLikeCount(commentId);
    await ref
        .read(appUserRepositoryProvider)
        .decreaseLikeCount(commentWriterId);
    await ref
        .read(postCommentLikesRepositoryProvider)
        .deletePostCommentLike(id);
  }

  Future<void> increasePostCommentDislike({
    required String id,
    required String uid,
    required String postId,
    required String commentId,
    required String commentWriterId,
    required String postWriterId,
    required String parentCommentId,
  }) async {
    await ref
        .read(postCommentsRepositoryProvider)
        .increaseDislikeCount(commentId);
    await ref
        .read(appUserRepositoryProvider)
        .increaseDislikeCount(commentWriterId);
    await ref.read(postCommentLikesRepositoryProvider).createPostCommentLike(
          id: id,
          uid: uid,
          postId: postId,
          commentId: commentId,
          commentWriterId: commentWriterId,
          postWriterId: postWriterId,
          parentCommentId: parentCommentId,
          isDislike: true,
          createdAt: DateTime.now(),
        );
  }

  Future<void> decreasePostCommentDislike({
    required String id,
    required String commentId,
    required String commentWriterId,
  }) async {
    await ref
        .read(postCommentsRepositoryProvider)
        .decreaseDislikeCount(commentId);
    await ref
        .read(appUserRepositoryProvider)
        .decreaseDislikeCount(commentWriterId);
    await ref
        .read(postCommentLikesRepositoryProvider)
        .deletePostCommentLike(id);
  }
}
