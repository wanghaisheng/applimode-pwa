import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostCommentReplyButton extends StatelessWidget {
  const PostCommentReplyButton({
    super.key,
    required this.comment,
  });

  final PostComment comment;

  @override
  Widget build(BuildContext context) {
    final mainColor = Theme.of(context).colorScheme.secondary;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        IconButton(
          onPressed: () => context.push(
            ScreenPaths.replies(
              comment.postId,
              comment.parentCommentId,
            ),
          ),
          icon: Icon(
            Icons.mode_comment_outlined,
            color: mainColor,
            size: 20,
          ),
        ),
        InkWell(
          onTap: () => context.push(
            ScreenPaths.replies(
              comment.postId,
              comment.parentCommentId,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              Format.formatNumber(context, comment.replyCount),
              style: textTheme.bodyLarge?.copyWith(color: mainColor),
            ),
          ),
        )
      ],
    );
  }
}
