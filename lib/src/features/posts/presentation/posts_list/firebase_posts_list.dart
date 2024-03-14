import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebasePostsList extends ConsumerWidget {
  const FirebasePostsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsQuery = ref.watch(postsRepositoryProvider).defaultPostsQuery();
    return FirestoreListView<Post>(
      query: postsQuery,
      emptyBuilder: (context) => Center(
        child: Text(context.loc.noPost),
      ),
      errorBuilder: (context, error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      loadingBuilder: (context) =>
          const Center(child: CircularProgressIndicator.adaptive()),
      itemBuilder: (context, doc) {
        final post = doc.data();
        return SmallPostsItem(post: post);
      },
    );
  }
}
