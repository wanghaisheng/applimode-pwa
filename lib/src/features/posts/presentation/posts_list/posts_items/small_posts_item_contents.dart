import 'package:applimode_app/src/common_widgets/title_text_widget.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/post_sub_info_one_line.dart';
import 'package:applimode_app/src/utils/remote_config_service.dart';

class SmallPostsItemContents extends StatelessWidget {
  const SmallPostsItemContents({
    super.key,
    required this.post,
    required this.writer,
    required this.mainCategory,
    this.isRankingPage = false,
    this.isLikeRanking = false,
    this.isDislikeRanking = false,
    this.isSumRanking = false,
    this.index,
  });

  final Post post;
  final AppUser writer;
  final List<MainCategory> mainCategory;
  final bool isRankingPage;
  final bool isLikeRanking;
  final bool isDislikeRanking;
  final bool isSumRanking;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: smallPostsItemTitleSize,
        );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isRankingPage && [0, 1, 2].contains(index)
            ? Row(
                children: [
                  if (isRankingPage && [0, 1, 2].contains(index))
                    Icon(
                      Icons.military_tech_outlined,
                      size: smallPostsItemTitleSize,
                      color: index == 0
                          ? const Color(0xFFFFD700)
                          : index == 1
                              ? const Color(0xFFC0C0C0)
                              : const Color(0xFFCD7F32),
                    ),
                  Expanded(
                    child: TitleTextWidget(
                      title: post.content,
                      textStyle: titleTextStyle,
                      maxLines: smallPostsItemTitleMaxLines,
                    ),
                  ),
                ],
              )
            : TitleTextWidget(
                title: post.content,
                textStyle: titleTextStyle,
                maxLines: smallPostsItemTitleMaxLines,
              ),
        const SizedBox(height: 4),
        PostSubInfoOneLine(
          post: post,
          mainCategory: mainCategory,
          showMainCategory: useCategory,
          writer: writer,
          showCommentPlusLikeCount:
              isLikeRanking || isDislikeRanking || isSumRanking
                  ? false
                  : showCommentPlusLikeCount,
          showLikeCount: isLikeRanking
              ? true
              : isDislikeRanking || isSumRanking
                  ? false
                  : showLikeCount,
          showDislikeCount: isDislikeRanking
              ? true
              : isLikeRanking || isSumRanking
                  ? false
                  : showDislikeCount,
          showSumCount: isSumRanking
              ? true
              : isLikeRanking || isDislikeRanking
                  ? false
                  : showSumCount,
          showCommentCount: showCommentCount,
          fontSize: smallPostsItemSubInfoSize,
          iconSize: smallPostsItemSubInfoSize + 2,
          showUserAdminLabel: showUserAdminLabel,
          showUserLikeLabel: showUserLikeCount,
          showUserDislikeLabel: showUserDislikeCount,
          showUserSumLabel: showUserSumCount,
          isThumbUpToHeart: isThumbUpToHeart,
        ),
      ],
    );
  }
}
