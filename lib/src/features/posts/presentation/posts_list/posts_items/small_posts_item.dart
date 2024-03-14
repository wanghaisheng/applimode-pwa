import 'package:applimode_app/src/common_widgets/responsive_widget.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_block_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item_contents.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/cached_border_image.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/remote_config_service.dart';

class SmallPostsItem extends ConsumerWidget {
  const SmallPostsItem({
    super.key,
    required this.post,
    this.index,
    this.isRankingPage = false,
    this.isLikeRanking = false,
    this.isDislikeRanking = false,
    this.isSumRanking = false,
  });

  final Post post;
  final int? index;
  final bool isRankingPage;
  final bool isLikeRanking;
  final bool isDislikeRanking;
  final bool isSumRanking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (post.id == deleted) {
      return const ResponsiveCenter(
        maxContentWidth: pcWidthBreakpoint,
        padding: EdgeInsets.zero,
        child: SmallBlockItem(),
      );
    }
    debugPrint('SmallPostsItem build');
    final writerAsync = ref.watch(writerFutureProvider(post.uid));
    final mainMediaUrl = post.mainImageUrl ?? post.mainVideoImageUrl;
    final mainCategory = ref.watch(remoteConfigServiceProvider).mainCategory;

    return ResponsiveCenter(
      maxContentWidth: pcWidthBreakpoint,
      padding: EdgeInsets.zero,
      child: AsyncValueWidget(
        value: writerAsync,
        data: (writer) {
          if (writer == null || writer.isBlock || post.isBlock) {
            return const SmallBlockItem();
          }
          return InkWell(
            onTap: () {
              context.push(
                ScreenPaths.post(post.id),
                extra: PostAndWriter(post: post, writer: writer),
              );
            },
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: listSmallItemHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: Row(
                          children: [
                            if (mainMediaUrl != null &&
                                mainMediaUrl.isNotEmpty) ...[
                              CachedBorderImage(
                                imgUrl: mainMediaUrl,
                                index: index,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: SmallPostsItemContents(
                                post: post,
                                writer: writer,
                                mainCategory: mainCategory,
                                isRankingPage: isRankingPage,
                                isLikeRanking: isLikeRanking,
                                isDislikeRanking: isDislikeRanking,
                                isSumRanking: isSumRanking,
                                index: index,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0,
                    indent: 24,
                    endIndent: 24,
                  ),
                  // 너무 진할 경우 사용
                  /*
              Divider(
                height: 0,
                thickness: 0,
                indent: 24,
                endIndent: 24,
                color: Theme.of(context).dividerColor.withOpacity(0.2),
              )
              */
                ],
              ),
            ),
          );
        },
        loadingWidget: const SizedBox(height: listSmallItemHeight),
      ),
    );
  }
}
