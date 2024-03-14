import 'package:applimode_app/src/features/like_users/post_comment_likes_list.dart';
import 'package:applimode_app/src/features/like_users/post_likes_list.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';

class LikeUsersScreen extends StatelessWidget {
  const LikeUsersScreen({
    super.key,
    this.isCommentLikes = false,
    this.postId,
    this.postCommentId,
    this.isDislike,
  });

  final bool isCommentLikes;
  final String? postId;
  final String? postCommentId;
  final bool? isDislike;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isDislike ?? false ? context.loc.dislikedBy : context.loc.likedBy),
      ),
      body: isCommentLikes
          ? PostCommentLikesList(
              postCommentId: postCommentId!,
              isDislike: isDislike,
            )
          : PostLikesList(
              postId: postId!,
              isDislike: isDislike,
            ),
    );
  }
}
