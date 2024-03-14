import 'package:applimode_app/src/common_widgets/center_circular_indicator.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_list_with_fs.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_screen_app_bar.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_screen_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCommentsScreen extends ConsumerWidget {
  const PostCommentsScreen({
    super.key,
    required this.postId,
    this.parentCommentId,
    this.postWriter,
  });

  final String postId;
  final String? parentCommentId;
  final AppUser? postWriter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(postCommentControllerProvider).isLoading;
    return Scaffold(
      appBar: PostCommentsScreenAppBar(
        isRepliesScreen: parentCommentId != null,
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: PostCommentsListWithFS(
                postId: postId,
                parentCommentId: parentCommentId,
              ),
            ),
          ),
          PostCommentsScreenBottomBar(
            postId: postId,
            parentCommentId: parentCommentId,
            postWriter: postWriter,
          ),
        ],
      ),
      floatingActionButton: isLoading ? const CenterCircularIndicator() : null,
    );
  }
}
