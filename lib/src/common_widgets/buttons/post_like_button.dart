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
    required this.writerId,
    this.isHeart = false,
    this.iconColor,
    this.iconSize,
    this.useIconButton = true,
    this.postWriter,
  });

  final String postId;
  final String writerId;
  final bool isHeart;
  final Color? iconColor;
  final double? iconSize;
  final bool useIconButton;
  final AppUser? postWriter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postLikesController = ref.watch(postLikesControllerProvider.notifier);
    final postLikesState = ref.watch(postLikesControllerProvider);

    final user = ref.watch(authRepositoryProvider).currentUser;
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
                          writerId: writerId,
                          postWriter: postWriter,
                          postLikeNotiString: context.loc.postLikeNoti,
                        )
                    : () => postLikesController.decreasePostLikeCount(
                          id: userPostLikes.first.id,
                          postId: postId,
                          writerId: writerId,
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
                          writerId: writerId,
                          postWriter: postWriter,
                          postLikeNotiString: context.loc.postLikeNoti,
                        )
                    : () => postLikesController.decreasePostLikeCount(
                          id: userPostLikes.first.id,
                          postId: postId,
                          writerId: writerId,
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
          );
  }
}
