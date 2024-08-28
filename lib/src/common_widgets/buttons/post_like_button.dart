import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/presentation/post_likes_controller.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';

class PostLikeButton extends ConsumerWidget {
  const PostLikeButton({
    super.key,
    required this.postId,
    required this.postWriterId,
    this.isHeart = false,
    this.iconColor,
    this.iconSize,
    this.useIconButton = true,
    this.postWriter,
  });

  final String postId;
  final String postWriterId;
  final bool isHeart;
  final Color? iconColor;
  final double? iconSize;
  final bool useIconButton;
  final AppUser? postWriter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postLikesController = ref.watch(postLikesControllerProvider.notifier);
    final postLikesState = ref.watch(postLikesControllerProvider);

    final user = ref.watch(authStateChangesProvider).value;
    final userPostLikes = user != null
        ? ref
            .watch(postLikesByUserFutureProvider(
              postId: postId,
              uid: user.uid,
            ))
            .value
        : null;

    return useIconButton
        ? IconButton(
            onPressed: user == null ||
                    userPostLikes == null ||
                    postLikesState.isLoading
                ? null
                : userPostLikes.isEmpty
                    ? () => postLikesController.increasePostLikeCount(
                          postId: postId,
                          postWriterId: postWriterId,
                          postWriter: postWriter,
                          postLikeNotiString: context.loc.postLikeNoti,
                        )
                    : () => postLikesController.decreasePostLikeCount(
                          id: userPostLikes.first.id,
                          postId: postId,
                          postWriterId: postWriterId,
                        ),
            icon: Icon(
              userPostLikes == null || userPostLikes.isEmpty
                  ? isHeart
                      ? Icons.favorite_outline_rounded
                      : Icons.thumb_up_alt_outlined
                  : isHeart
                      ? Icons.favorite_rounded
                      : Icons.thumb_up,
              color: iconColor ?? Theme.of(context).colorScheme.secondary,
              size: iconSize,
            ),
          )
        : InkWell(
            onTap: user == null ||
                    userPostLikes == null ||
                    postLikesState.isLoading
                ? null
                : userPostLikes.isEmpty
                    ? () => postLikesController.increasePostLikeCount(
                          postId: postId,
                          postWriterId: postWriterId,
                          postWriter: postWriter,
                          postLikeNotiString: context.loc.postLikeNoti,
                        )
                    : () => postLikesController.decreasePostLikeCount(
                          id: userPostLikes.first.id,
                          postId: postId,
                          postWriterId: postWriterId,
                        ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: Icon(
                userPostLikes == null || userPostLikes.isEmpty
                    ? isHeart
                        ? Icons.favorite_outline_rounded
                        : Icons.thumb_up_alt_outlined
                    : isHeart
                        ? Icons.favorite_rounded
                        : Icons.thumb_up,
                color: iconColor ?? Theme.of(context).colorScheme.secondary,
                size: iconSize,
              ),
            ),
          );
  }
}
