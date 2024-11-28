import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/buttons/post_comment_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/post_dislike_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/post_like_button.dart';
import 'package:applimode_app/src/common_widgets/buttons/post_sum_button.dart';
import 'package:applimode_app/src/exceptions/app_exception.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/presentation/post_likes_controller.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/adaptive_back.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';

class PostScreenBottomBar extends ConsumerStatefulWidget {
  const PostScreenBottomBar({
    super.key,
    required this.post,
    this.postWriter,
  });

  final Post post;
  final AppUser? postWriter;

  @override
  ConsumerState<PostScreenBottomBar> createState() =>
      _PostScreenBottomBarState();
}

class _PostScreenBottomBarState extends ConsumerState<PostScreenBottomBar> {
  late Post currentPost;

  @override
  void initState() {
    super.initState();
    currentPost = widget.post;
  }

  // update post like, dislike count
  Future<void> _updateCount(List<String> updatedPostIds) async {
    if (updatedPostIds.isNotEmpty && updatedPostIds.contains(widget.post.id)) {
      final updatedPost =
          await ref.read(postsRepositoryProvider).fetchPost(widget.post.id);
      if (updatedPost != null) {
        currentPost = updatedPost;
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mainColor = colorScheme.secondary;
    final countTextStyle = textTheme.bodyMedium?.copyWith(color: mainColor);
    final isIosWeb = kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    final adminSettings = ref.watch(adminSettingsProvider);

    ref.listen(postLikesControllerProvider, (_, state) {
      if (state.error is NeedLogInException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.needLogin);
      } else if (state.error is PageNotFoundException) {
        state.showMessageSnackBarOnError(context,
            content: context.loc.pageNotFound);
        adaptiveBack(context);
      } else {
        state.showAlertDialogOnError(context, content: state.error.toString());
      }
    });

    ref.listen(updatedPostIdsListProvider, (_, next) {
      _updateCount(next);
    });

    return InkWell(
      onTap: () {
        if (adminSettings.showCommentCount) {
          context.push(
            ScreenPaths.comments(widget.post.id),
            extra: widget.postWriter,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: isIosWeb ? iosWebBottomSafeArea : 8,
        ),
        color: colorScheme.onInverseSurface,
        // height: 96,
        child: SafeArea(
          child: Row(
            children: [
              if (adminSettings.showLikeCount) ...[
                PostLikeButton(
                  postId: currentPost.id,
                  postWriterId: currentPost.uid,
                  isHeart: adminSettings.isThumbUpToHeart,
                  postWriter: widget.postWriter,
                  iconSize: postScreenBottomBarIconSize,
                ),
                InkWell(
                  onTap: () =>
                      context.push(ScreenPaths.postLikes(currentPost.id)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 16),
                    child: Text(
                      Format.formatNumber(context, currentPost.likeCount),
                      style: countTextStyle,
                    ),
                  ),
                ),
              ],
              if (adminSettings.showDislikeCount) ...[
                PostDislikeButton(
                  postId: currentPost.id,
                  postWriterId: currentPost.uid,
                  iconSize: postScreenBottomBarIconSize,
                ),
                InkWell(
                  onTap: () =>
                      context.push(ScreenPaths.postDislikes(currentPost.id)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 16),
                    child: Text(
                      Format.formatNumber(context, currentPost.dislikeCount),
                      style: countTextStyle,
                    ),
                  ),
                ),
              ],
              if (adminSettings.showSumCount) ...[
                const PostSumButton(
                  iconSize: postScreenBottomBarIconSize,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 16),
                  child: Text(
                    Format.formatNumber(context, currentPost.sumCount),
                    style: countTextStyle,
                  ),
                ),
              ],
              if (adminSettings.showCommentCount) ...[
                PostCommentButton(
                  postId: currentPost.id,
                  postWriter: widget.postWriter,
                  iconSize: postScreenBottomBarIconSize,
                ),
                InkWell(
                  onTap: () => context.push(
                    ScreenPaths.comments(currentPost.id),
                    extra: widget.postWriter,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 16),
                    child: Text(
                      Format.formatNumber(
                          context, currentPost.postCommentCount),
                      style: countTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Text(
                      context.loc.leaveComment,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelLarge?.copyWith(color: mainColor),
                    ),
                  ),
                ),
                Icon(
                  Icons.unfold_more_outlined,
                  color: mainColor,
                  size: postScreenBottomBarIconSize,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
