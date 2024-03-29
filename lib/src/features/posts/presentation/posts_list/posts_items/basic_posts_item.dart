import 'package:applimode_app/env/env.dart';
import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/common_widgets/animated_color_box.dart';
import 'package:applimode_app/src/common_widgets/main_label.dart';
import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/src/common_widgets/user_items/writer_item.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/basic_block_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/page_item_buttons.dart';
import 'package:applimode_app/src/features/video_player/main_video_player.dart';
import 'package:applimode_app/src/utils/get_full_url.dart';
import 'package:applimode_app/src/utils/get_max_width.dart';
import 'package:applimode_app/src/utils/posts_item_playing_state.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/routing/app_router.dart';

class BasicPostsItem extends ConsumerWidget {
  const BasicPostsItem({
    super.key,
    required this.post,
    this.index,
    this.aspectRatio,
    this.isPage = false,
    this.isTappable = true,
    this.showMainLabel = true,
    this.showVideoTitle = true,
  });

  final Post post;
  final int? index;
  final double? aspectRatio;
  final bool isPage;
  final bool isTappable;
  final bool showMainLabel;
  final bool showVideoTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('BasicPostsItem build');
    final writerAsync = ref.watch(writerFutureProvider(post.uid));
    final appSettings = ref.watch(appSettingsControllerProvider);
    final mainImageUrl = post.mainImageUrl;
    final mainVideoUrl = post.mainVideoUrl;
    final mainVideoImageUrl = post.mainVideoImageUrl;
    final isVideo = mainVideoUrl != null &&
        mainVideoUrl.trim().isNotEmpty &&
        !Regex.ytRegexB.hasMatch(mainVideoUrl);
    final hasTitle = post.title.isNotEmpty;

    final postTitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: basicPostsItemTitleFontsize,
        );

    final screenWidth = MediaQuery.sizeOf(context).width;

    return AsyncValueWidget(
      value: writerAsync,
      data: (writer) {
        final isContent = writer != null && !writer.isBlock && !post.isBlock;
        if (writer == null) {
          return BasicBlockItem(
            aspectRatio: aspectRatio,
            isPage: isPage,
            index: index,
          );
        }
        if (writer.isBlock || post.isBlock) {
          return BasicBlockItem(
            aspectRatio: aspectRatio,
            isPage: isPage,
            index: index,
            postId: post.id,
            postAndWriter: PostAndWriter(post: post, writer: writer),
          );
        }
        return InkWell(
          onTap: isContent && isTappable && !isVideo
              ? () => context.push(
                    ScreenPaths.post(post.id),
                    extra: PostAndWriter(post: post, writer: writer),
                  )
              : null,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: aspectRatio ?? 1.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /*
                    if (!isContent)
                      AnimatedColorBox(
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 64),
                          child: SafeArea(
                            child: TitleTextWidget(
                              title: context.loc.deletedPost,
                              textStyle: postTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    */
                    if (isContent && isVideo)
                      MainVideoPlayer(
                        // when delete video post, resolve old video remain
                        key: UniqueKey(),
                        videoUrl: getFsUrl(mainVideoUrl)!,
                        videoImageUrl: getFsUrl(mainVideoImageUrl),
                        aspectRatio: aspectRatio ?? 1.0,
                        writer: writer,
                        post: post,
                        index: index,
                        isPage: isPage,
                        showVideoTitle: showVideoTitle,
                      ),
                    if (isContent && !isVideo)
                      mainImageUrl != null
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    getFsUrl(mainImageUrl)!,
                                    headers: useRTwoSecureGet
                                        ? {
                                            "X-Custom-Auth-Key": Env.workerKey,
                                          }
                                        : null,
                                  ),
                                ),
                              ),
                            )
                          : AnimatedColorBox(
                              index: index,
                              child: Padding(
                                padding: const EdgeInsets.all(64.0),
                                child: SafeArea(
                                  child: TitleTextWidget(
                                    title: post.title,
                                    textStyle: postTitleStyle,
                                    maxLines: basicPostsItemMiddleTitleMaxLines,
                                    textAlign: switch (titleTextAlign) {
                                      TitleTextAlign.start => TextAlign.start,
                                      TitleTextAlign.center => TextAlign.center,
                                      TitleTextAlign.end => TextAlign.end,
                                    },
                                  ),
                                ),
                              ),
                            ),
                    /*
                      Padding(
                        padding: const EdgeInsets.all(64.0),
                        child: SafeArea(
                          child: TitleTextWidget(
                            title: post.title,
                            textStyle: postTitleStyle,
                            maxLines: basicPostsItemTitleMaxLines,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      */
                    if (isContent) ...[
                      Positioned(
                        left: 16,
                        bottom: 24,
                        child: SafeArea(
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(postsItemPlayingStateProvider.notifier)
                                  .setFalseAndTrue();
                              context.push(
                                ScreenPaths.post(post.id),
                                extra: PostAndWriter(
                                  post: post,
                                  writer: writer,
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WriterItem(
                                  writer: writer,
                                  post: post,
                                  width: getMaxWidth(context),
                                  profileImagesize: basicPostsItemProfileSize,
                                  nameColor: Colors.white,
                                  showSubtitle: true,
                                  showMainCategory: useCategory,
                                  showLikeCount: isPage ? false : showLikeCount,
                                  showDislikeCount:
                                      isPage ? false : showDislikeCount,
                                  showCommentCount:
                                      isPage ? false : showCommentCount,
                                  showCommentPlusLikeCount:
                                      isPage ? false : showCommentPlusLikeCount,
                                  showSumCount: isPage ? false : showSumCount,
                                  isThumbUpToHeart: isThumbUpToHeart,
                                  captionColor: Colors.white,
                                  countColor: Colors.white,
                                  index: index,
                                  categoryColor: Colors.white,
                                  nameSize: basicPostsItemNameSize,
                                  subInfoFontSize: basicPostsItemSubInfoSize,
                                  subInfoIconSize:
                                      basicPostsItemSubInfoSize + 2,
                                  writerLabelFontSize:
                                      basicPostsItemNameSize - 6,
                                ),
                                if ((mainImageUrl != null || isVideo) &&
                                    hasTitle) ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: getMaxWidth(context),
                                    child: TitleTextWidget(
                                      title: post.title,
                                      textStyle: postTitleStyle,
                                      maxLines: isVideo
                                          ? basicPostsItemVideoTitleMaxLines
                                          : basicPostsItemBottomTitleMaxLines,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (isContent &&
                        (showAppStyleOption
                            ? appSettings.appStyle == 2
                            : postsListType == PostsListType.page))
                      Positioned(
                        right: 16,
                        bottom: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? useDirectUploadButton
                                ? 160
                                : 120
                            : useDirectUploadButton
                                ? 160
                                : 80,
                        child: SafeArea(
                          child: PageItemButtons(
                            post: post,
                            postWriter: writer,
                          ),
                        ),
                      ),
                    if (isContent && showMainLabel && post.isHeader)
                      const MainLabel(left: 16, top: 24),
                  ],
                ),
              ),
              if (!isPage && screenWidth <= pcWidthBreakpoint)
                const SizedBox(height: cardBottomPadding),
            ],
          ),
        );
      },
    );
  }
}
