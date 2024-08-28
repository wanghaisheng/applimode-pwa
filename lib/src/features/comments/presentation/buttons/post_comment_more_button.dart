import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCommentMoreButton extends ConsumerWidget {
  const PostCommentMoreButton({
    super.key,
    required this.comment,
    required this.writerId,
    this.parentCommentId,
  });

  final PostComment comment;
  final String writerId;
  final String? parentCommentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final appUser = user != null
        ? ref.watch(appUserFutureProvider(user.uid))
        : const AsyncData(null);

    final postCommentState = ref.watch(postCommentControllerProvider);

    return AsyncValueWidget(
      value: appUser,
      data: (appUser) {
        /*
        if (appUser == null ||
            (user != null && user.uid != writerId && !appUser.isAdmin)) {
          return const SizedBox.shrink();
        }
        */
        return PopupMenuButton(
          tooltip: 'delete or report comment',
          position: PopupMenuPosition.under,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 4),
            child: Icon(
              Icons.more_horiz,
              size: 18,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          itemBuilder: (context) {
            return [
              if (user != null &&
                  appUser != null &&
                  (user.uid == writerId || appUser.isAdmin))
                PopupMenuItem(
                  onTap: postCommentState.isLoading
                      ? null
                      : () async {
                          await ref
                              .read(postCommentControllerProvider.notifier)
                              .deleteComment(
                                id: comment.id,
                                parentCommentId: comment.parentCommentId,
                                postId: comment.postId,
                                isReply: parentCommentId != null,
                                commentWriterId: comment.uid,
                                isAdmin: appUser.isAdmin,
                                imageUrl: comment.imageUrl,
                              );
                        },
                  child: Text(context.loc.deleteComment),
                ),
            ];
          },
        );
      },
    );
  }
}
