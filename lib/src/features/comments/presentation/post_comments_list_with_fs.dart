import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_item.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_list_state.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCommentsListWithFS extends ConsumerWidget {
  const PostCommentsListWithFS({
    super.key,
    required this.postId,
    this.parentCommentId,
    this.emptyString,
  });

  final String postId;
  final String? parentCommentId;
  final String? emptyString;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(postCommentsListStateControllerProvider);
    final commentsQuery = parentCommentId == null
        ? ref.watch(postCommentsQueryProvider(
            postId: postId,
            byCreatedAt: listState.byCreatedAt,
            byCommentCount: listState.byCommentCount,
            byLikeCount: listState.byLikeCount,
            byDislikeCount: listState.byDislikeCount,
            bySumCount: listState.bySumCount,
          ))
        : ref.watch(postCommentRepliesQueryProvider(parentCommentId!));
    return FirestoreListView(
      query: commentsQuery,
      pageSize: firebaseListFetchLimit,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      emptyBuilder: (context) => Center(
        child: Text(emptyString != null ? emptyString! : context.loc.noComment),
      ),
      errorBuilder: (context, error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      loadingBuilder: (context) =>
          const Center(child: CupertinoActivityIndicator()),
      itemBuilder: (context, doc) {
        final comment = doc.data();
        return PostCommentsItem(
          comment: comment,
          parentCommentId: parentCommentId,
        );
      },
    );
  }
}
