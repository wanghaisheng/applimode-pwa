import 'package:applimode_app/src/features/comments/data/post_comments_repository.dart';
import 'package:applimode_app/src/features/comments/domain/post_comment.dart';
import 'package:applimode_app/src/features/comments/presentation/post_comments_item.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:go_router/go_router.dart';

class ProfileCommentsList extends ConsumerWidget {
  const ProfileCommentsList({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsQuery = ref.watch(postCommentsQueryProvider(uid: uid));
    return FirestoreListView<PostComment>(
      query: commentsQuery,
      emptyBuilder: (context) => Center(
        child: Text(context.loc.noComment),
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
          isProfile: true,
          onPressed: () => context.push(ScreenPaths.post(comment.postId)),
        );
      },
    );
  }
}
