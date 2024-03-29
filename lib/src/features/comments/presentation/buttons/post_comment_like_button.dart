import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment_like.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostCommentLikeButton extends ConsumerStatefulWidget {
  const PostCommentLikeButton({
    super.key,
    required this.comment,
    required this.likeCount,
    this.isHeart = false,
    this.commentWriter,
  });

  final PostComment comment;
  final int likeCount;
  final bool isHeart;
  final AppUser? commentWriter;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostCommentLikeButtonState();
}

class _PostCommentLikeButtonState extends ConsumerState<PostCommentLikeButton> {
  List<PostCommentLike>? userCommentLikes;

  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).colorScheme.secondary;
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(authStateChangesProvider).value;

    final postCommentController =
        ref.watch(postCommentControllerProvider.notifier);
    final postCommentState = ref.watch(postCommentControllerProvider);

    if (user != null) {
      userCommentLikes = ref
          .watch(postCommentLikesByUserFutureProvider(
            commentId: widget.comment.id,
            uid: user.uid,
          ))
          .value;
    }

    return Row(
      children: [
        IconButton(
          onPressed: userCommentLikes == null || postCommentState.isLoading
              ? null
              : userCommentLikes!.isEmpty
                  ? () async {
                      await postCommentController.increasePostCommentLike(
                        postId: widget.comment.postId,
                        commentId: widget.comment.id,
                        writerId: widget.comment.uid,
                        commentWriter: widget.commentWriter,
                        commentLikeNotiString: context.loc.commentLikeNoti,
                      );
                    }
                  : () async {
                      await postCommentController.decreasePostCommentLike(
                        id: userCommentLikes!.first.id,
                        commentId: widget.comment.id,
                        writerId: widget.comment.uid,
                      );
                    },
          icon: Icon(
            userCommentLikes == null || userCommentLikes!.isEmpty
                ? widget.isHeart
                    ? Icons.favorite_outline_rounded
                    : Icons.thumb_up_outlined
                : widget.isHeart
                    ? Icons.favorite_rounded
                    : Icons.thumb_up,
            color: mainColor,
            size: 20,
          ),
        ),
        InkWell(
          onTap: () {
            context.push(ScreenPaths.commentLikes(widget.comment.id));
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              Format.formatNumber(context, widget.likeCount),
              style: textTheme.bodyLarge?.copyWith(color: mainColor),
            ),
          ),
        ),
      ],
    );
  }
}
