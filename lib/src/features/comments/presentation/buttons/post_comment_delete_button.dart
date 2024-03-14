import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCommentDeleteButton extends ConsumerStatefulWidget {
  const PostCommentDeleteButton({
    super.key,
    required this.comment,
    required this.writerId,
    this.parentCommentId,
  });

  final PostComment comment;
  final String writerId;
  final String? parentCommentId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostCommentDeleteButtonState();
}

class _PostCommentDeleteButtonState
    extends ConsumerState<PostCommentDeleteButton> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authRepositoryProvider).currentUser!;
    final appUser = ref.watch(appUserFutureProvider(user.uid));

    final postCommentState = ref.watch(postCommentControllerProvider);

    return appUser.when(
      data: (appUser) {
        if (appUser == null ||
            user.uid != widget.writerId && !appUser.isAdmin) {
          return const SizedBox.shrink();
        }
        return IconButton(
          onPressed: postCommentState.isLoading
              ? null
              : () async {
                  await ref
                      .read(postCommentControllerProvider.notifier)
                      .deleteComment(
                        id: widget.comment.id,
                        parentCommentId: widget.comment.parentCommentId,
                        postId: widget.comment.postId,
                        isReply: widget.parentCommentId != null,
                        writerId: widget.comment.uid,
                        isAdmin: appUser.isAdmin,
                        imageUrl: widget.comment.imageUrl,
                      );
                },
          icon: Icon(
            Icons.delete_outline_rounded,
            color: Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
