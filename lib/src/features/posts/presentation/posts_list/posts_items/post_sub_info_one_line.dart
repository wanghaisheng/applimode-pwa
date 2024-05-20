import 'package:applimode_app/src/common_widgets/writer_label.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/utils/check_category.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';

// 길이가 길경우 짤리는 현상 방지하기 위해
// SingleChildScrollView 로 래핑해주고
// 사용자 이름의 Flexible 은 언래핑해주었음.

class PostSubInfoOneLine extends StatelessWidget {
  const PostSubInfoOneLine({
    super.key,
    required this.post,
    this.mainCategory,
    this.writer,
    this.showMainCategory,
    this.showCommentPlusLikeCount,
    this.showSumCount,
    this.showLikeCount,
    this.showDislikeCount,
    this.showCommentCount,
    this.isThumbUpToHeart,
    this.captionColor,
    this.countColor,
    this.categoryColor,
    this.fontSize,
    this.iconSize,
    this.showUserAdminLabel,
    this.showUserLikeLabel,
    this.showUserDislikeLabel,
    this.showUserSumLabel,
  });

  final Post post;
  final List<MainCategory>? mainCategory;
  final AppUser? writer;
  final bool? showMainCategory;
  final bool? showCommentPlusLikeCount;
  final bool? showSumCount;
  final bool? showLikeCount;
  final bool? showDislikeCount;
  final bool? showCommentCount;
  final bool? isThumbUpToHeart;
  final Color? captionColor;
  final Color? countColor;
  final Color? categoryColor;
  final double? fontSize;
  final double? iconSize;
  final bool? showUserAdminLabel;
  final bool? showUserLikeLabel;
  final bool? showUserDislikeLabel;
  final bool? showUserSumLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final defaultCountColor = Theme.of(context).colorScheme.primary;
    final captionStyle = textTheme.bodySmall?.copyWith(
      color: captionColor,
      fontSize: fontSize,
    );
    final countStyle = textTheme.labelMedium?.copyWith(
      color: countColor ?? defaultCountColor,
      fontSize: fontSize,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (mainCategory != null && (showMainCategory ?? false)) ...[
            Text(
              checkCategory(mainCategory!, post.category).title,
              style: captionStyle?.copyWith(
                  color: categoryColor ??
                      checkCategory(mainCategory!, post.category).color),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '  ·  ',
              style: captionStyle,
            ),
          ],
          Text(
            Format.toAgo(context, post.createdAt),
            style: captionStyle,
            overflow: TextOverflow.ellipsis,
          ),
          // comment plus like count
          if (showCommentPlusLikeCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              Icons.trending_up,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(
                  context, post.postCommentCount + post.likeCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // like count
          if (showLikeCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              isThumbUpToHeart ?? false
                  ? Icons.favorite_outline_rounded
                  : Icons.thumb_up_outlined,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(context, post.likeCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // dislike count
          if (showDislikeCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              Icons.thumb_down_outlined,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(context, post.dislikeCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // sum count
          if (showSumCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              Icons.swap_vert_outlined,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(context, post.sumCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // comment count
          if (showCommentCount ?? false) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: iconSize ?? 14,
              color: countColor,
            ),
            const SizedBox(width: 4),
            Text(
              Format.formatNumber(context, post.postCommentCount),
              style: countStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // writer
          if (writer != null) ...[
            Text(
              '  ·  ',
              style: captionStyle,
            ),
            if ((showUserAdminLabel ?? false) && writer!.isAdmin)
              const Icon(
                Icons.verified_user,
                color: Color(userAdminColor),
                size: smallPostsItemSubInfoSize,
              ),
            if (writer!.verified)
              const Icon(
                Icons.verified,
                color: Color(0xFF00a5e3),
                size: smallPostsItemSubInfoSize,
              ),
            if (writer!.verified ||
                ((showUserAdminLabel ?? false) && writer!.isAdmin))
              const SizedBox(width: 2),
            Text(
              Format.getShortName(writer!.displayName),
              style: captionStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          // writer like count label
          if ((showUserLikeLabel ?? false) && writer != null) ...[
            const SizedBox(width: 4),
            WriterLabel(
              // label: context.loc.likesCount,
              iconData: Icons.arrow_upward_rounded,
              color: const Color(userLikeCountColor),
              count: writer!.likeCount,
              labelSize: smallPostsItemSubInfoSize - 4,
            ),
          ],
          // writer dislike count label
          if ((showUserDislikeLabel ?? false) && writer != null) ...[
            const SizedBox(width: 4),
            WriterLabel(
              // label: context.loc.dislikesCount,
              iconData: Icons.arrow_downward_rounded,
              color: const Color(userDislikeCountColor),
              count: writer!.dislikeCount,
              labelSize: smallPostsItemSubInfoSize - 4,
            ),
          ],
          // writer sum count label
          if ((showUserSumLabel ?? false) && writer != null) ...[
            const SizedBox(width: 4),
            WriterLabel(
              // label: context.loc.sumCount,
              iconData: Icons.swap_vert_rounded,
              color: const Color(userSumCountColor),
              count: writer!.sumCount,
              labelSize: smallPostsItemSubInfoSize - 4,
            ),
          ],
        ],
      ),
    );
  }
}
