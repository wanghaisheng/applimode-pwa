import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/post/presentation/post_likes_controller.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDislikeButton extends ConsumerWidget {
  const PostDislikeButton({
    super.key,
    required this.postId,
    required this.postWriterId,
    this.iconColor,
    this.iconSize,
    this.useIconButton = true,
  });

  final String postId;
  final String postWriterId;
  final Color? iconColor;
  final double? iconSize;
  final bool useIconButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postLikesController = ref.watch(postLikesControllerProvider.notifier);
    final postLikesState = ref.watch(postLikesControllerProvider);

    final user = ref.watch(authStateChangesProvider).value;
    final userPostDislikes = user != null
        ? ref
            .watch(postLikesByUserFutureProvider(
              postId: postId,
              uid: user.uid,
              isDislike: true,
            ))
            .value
        : null;

    return useIconButton
        ? IconButton(
            onPressed: user == null ||
                    userPostDislikes == null ||
                    postLikesState.isLoading
                ? null
                : userPostDislikes.isEmpty
                    ? () => postLikesController.increasePostDislikeCount(
                          postId: postId,
                          postWriterId: postWriterId,
                        )
                    : () => postLikesController.decreasePostDislikeCount(
                          id: userPostDislikes.first.id,
                          postId: postId,
                          postWriterId: postWriterId,
                        ),
            icon: Icon(
              userPostDislikes == null || userPostDislikes.isEmpty
                  ? Icons.thumb_down_alt_outlined
                  : Icons.thumb_down,
              color: iconColor ?? Theme.of(context).colorScheme.secondary,
              size: iconSize,
            ),
          )
        : InkWell(
            onTap: user == null ||
                    userPostDislikes == null ||
                    postLikesState.isLoading
                ? null
                : userPostDislikes.isEmpty
                    ? () => postLikesController.increasePostDislikeCount(
                          postId: postId,
                          postWriterId: postWriterId,
                        )
                    : () => postLikesController.decreasePostDislikeCount(
                          id: userPostDislikes.first.id,
                          postId: postId,
                          postWriterId: postWriterId,
                        ),
            child: Icon(
              userPostDislikes == null || userPostDislikes.isEmpty
                  ? Icons.thumb_down_alt_outlined
                  : Icons.thumb_down,
              color: iconColor ?? Theme.of(context).colorScheme.secondary,
              size: iconSize,
            ),
          );
  }
}
