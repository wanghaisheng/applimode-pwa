import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment_like.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostCommentDislikeButton extends ConsumerStatefulWidget {
  const PostCommentDislikeButton({
    super.key,
    required this.comment,
    required this.dislikeCount,
  });

  final PostComment comment;
  final int dislikeCount;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostCommentDislikeButtonState();
}

class _PostCommentDislikeButtonState
    extends ConsumerState<PostCommentDislikeButton> {
  List<PostCommentLike>? userCommentDislikes;
  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).colorScheme.secondary;
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(authStateChangesProvider).value;

    final postCommentController =
        ref.watch(postCommentControllerProvider.notifier);
    final postCommentState = ref.watch(postCommentControllerProvider);

    if (user != null) {
      userCommentDislikes = ref
          .watch(postCommentLikesByUserFutureProvider(
            commentId: widget.comment.id,
            uid: user.uid,
            isDislike: true,
          ))
          .value;
    }

    return Row(
      children: [
        InkWell(
          onTap: userCommentDislikes == null || postCommentState.isLoading
              ? null
              : userCommentDislikes!.isEmpty
                  ? () async {
                      await postCommentController.increasePostCommentDislike(
                        postId: widget.comment.postId,
                        commentId: widget.comment.id,
                        commentWriterId: widget.comment.uid,
                        postWriterId: widget.comment.postWriterId,
                        parentCommentId: widget.comment.parentCommentId,
                      );
                    }
                  : () async {
                      await postCommentController.decreasePostCommentDislike(
                        id: userCommentDislikes!.first.id,
                        commentId: widget.comment.id,
                        commentWriterId: widget.comment.uid,
                      );
                    },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 4),
            child: Icon(
              userCommentDislikes == null || userCommentDislikes!.isEmpty
                  ? Icons.thumb_down_outlined
                  : Icons.thumb_down,
              color: mainColor,
              size: 18,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            context.push(ScreenPaths.commentDislikes(widget.comment.id));
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 16),
            child: Text(
              Format.formatNumber(context, widget.dislikeCount),
              style: textTheme.bodyMedium?.copyWith(color: mainColor),
            ),
          ),
        ),
      ],
    );
  }
}
