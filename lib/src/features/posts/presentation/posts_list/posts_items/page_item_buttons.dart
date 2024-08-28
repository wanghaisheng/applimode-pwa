import 'package:applimode_app/src/common_widgets/buttons/post_comment_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/post_dislike_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/post_like_button.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/presentation/post_likes_controller.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/show_message_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PageItemButtons extends ConsumerWidget {
  const PageItemButtons({
    super.key,
    required this.post,
    this.postWriter,
  });

  final Post post;
  final AppUser? postWriter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(postLikesControllerProvider, (_, next) {
      if (!next.isLoading && next.hasError) {
        showMessageSnackBar(context, context.loc.deletedPost);
        ref.read(postsListStateProvider.notifier).set(nowToInt());
      }
    });

    final adminSettings = ref.watch(adminSettingsProvider);
    return Column(
      children: [
        if (adminSettings.showLikeCount) ...[
          PostLikeButton(
            postId: post.id,
            postWriterId: post.uid,
            isHeart: adminSettings.isThumbUpToHeart,
            iconColor: const Color(basicPostsItemButtonColor),
            iconSize: basicPostsItemButtonSize,
            useIconButton: false,
            postWriter: postWriter,
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => context.push(ScreenPaths.postLikes(post.id)),
            child: Text(
              Format.formatNumber(context, post.likeCount),
              style: const TextStyle(
                fontSize: basicPostsItemButtonFontSize,
                color: Color(basicPostsItemButtonColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (adminSettings.showDislikeCount &&
            MediaQuery.of(context).orientation == Orientation.portrait) ...[
          PostDislikeButton(
            postId: post.id,
            postWriterId: post.uid,
            iconColor: const Color(basicPostsItemButtonColor),
            iconSize: basicPostsItemButtonSize,
            useIconButton: false,
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => context.push(ScreenPaths.postDislikes(post.id)),
            child: Text(
              Format.formatNumber(context, post.dislikeCount),
              style: const TextStyle(
                fontSize: basicPostsItemButtonFontSize,
                color: Color(basicPostsItemButtonColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (adminSettings.showCommentCount) ...[
          PostCommentButton(
            postId: post.id,
            iconColor: const Color(basicPostsItemButtonColor),
            iconSize: basicPostsItemButtonSize,
            useIconButton: false,
            postWriter: postWriter,
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => context.push(
              ScreenPaths.comments(post.id),
              extra: postWriter,
            ),
            child: Text(
              Format.formatNumber(context, post.postCommentCount),
              style: const TextStyle(
                fontSize: basicPostsItemButtonFontSize,
                color: Color(basicPostsItemButtonColor),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
