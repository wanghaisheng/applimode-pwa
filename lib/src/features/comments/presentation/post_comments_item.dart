import 'package:applimode_app/src/common_widgets/image_widgets/cached_circle_image.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/cached_padding_image.dart';
import 'package:applimode_app/src/constants/color_palettes.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/presentation/buttons/post_comment_like_button.dart';
import 'package:applimode_app/src/features/comments/presentation/buttons/post_comment_reply_button.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/features/comments/presentation/buttons/post_comment_delete_button.dart';
import 'package:applimode_app/src/features/comments/presentation/buttons/post_comment_dislike_button.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostCommentsItem extends ConsumerWidget {
  const PostCommentsItem({
    super.key,
    required this.comment,
    this.parentCommentId,
    this.isProfile = false,
    this.isRanking = false,
    this.onPressed,
  });

  static const profileSize = 32.0;

  final PostComment comment;
  final String? parentCommentId;
  final bool isProfile;
  final bool isRanking;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('post comment item build');
    ref.listen(postCommentControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authStateChangesProvider).value;
    final adminSettings = ref.watch(adminSettingsProvider);

    final writerAsync = ref.watch(writerFutureProvider(comment.uid));

    return writerAsync.when(
      data: (writer) {
        return writer == null || writer.isBlock
            ? const SizedBox.shrink()
            : InkWell(
                onTap: () {
                  if (onPressed != null) {
                    onPressed!.call();
                  } else if (parentCommentId == null && !comment.isReply) {
                    context.push(ScreenPaths.replies(
                      comment.postId,
                      comment.id,
                    ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 24,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (comment.isReply && !isProfile && !isRanking)
                        const SizedBox(width: 48),
                      InkWell(
                        onTap: () =>
                            context.push(ScreenPaths.profile(writer.uid)),
                        child: writer.photoUrl == null
                            ? Container(
                                width: profileSize,
                                height: profileSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: pastelColorPalettes[
                                      comment.hashCode % 24],
                                ),
                              )
                            : CachedCircleImage(
                                imageUrl: writer.photoUrl!,
                                size: profileSize,
                              ),
                      ),
                      /*
                      if (writer.photoUrl == null)
                        Container(
                          width: profileSize,
                          height: profileSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: pastelColorPalettes[Random().nextInt(25)],
                          ),
                        ),
                      if (writer.photoUrl != null)
                        CachedCircleImage(
                          imageUrl: writer.photoUrl!,
                          size: profileSize,
                        ),
                        */
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${writer.displayName}  ·  ${Format.toAgo(context, comment.createdAt)}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.secondary,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // seperated username and datetime
                            /*
                            Row(
                              children: [
                                Text(
                                  writer.displayName,
                                  style: textTheme.labelMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '  ·  ${Format.toAgo(context, comment.createdAt)}',
                                  style: textTheme.bodySmall?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                )
                              ],
                            ),
                            */
                            const SizedBox(height: 4),
                            if (comment.imageUrl != null)
                              CachedPaddingImage(
                                imageUrl: comment.imageUrl!,
                              ),
                            if (comment.imageUrl == null &&
                                comment.content != null)
                              Text(
                                comment.content!,
                                style: textTheme.bodyLarge,
                              ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (adminSettings.showLikeCount) ...[
                                  PostCommentLikeButton(
                                    comment: comment,
                                    likeCount: comment.likeCount,
                                    isHeart: adminSettings.isThumbUpToHeart,
                                    commentWriter: writer,
                                  ),
                                ],
                                if (adminSettings.showDislikeCount) ...[
                                  const SizedBox(width: 12),
                                  PostCommentDislikeButton(
                                    comment: comment,
                                    dislikeCount: comment.dislikeCount,
                                  ),
                                ],
                                if (parentCommentId == null &&
                                    adminSettings.showCommentCount) ...[
                                  const SizedBox(width: 12),
                                  PostCommentReplyButton(comment: comment),
                                ],
                                if (parentCommentId == null &&
                                        !comment.isReply ||
                                    parentCommentId != null &&
                                        comment.isReply ||
                                    isProfile) ...[
                                  const SizedBox(width: 12),
                                  if (user != null)
                                    PostCommentDeleteButton(
                                      comment: comment,
                                      writerId: writer.uid,
                                      parentCommentId: parentCommentId,
                                    ),
                                ],
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
      error: (error, stackTrace) {
        debugPrint(error.toString());
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
    );
  }
}
