import 'package:applimode_app/src/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/basic_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubPostsScreen extends ConsumerWidget {
  const SubPostsScreen({
    super.key,
    required this.query,
    this.appBarTitle,
    this.type = PostsListType.square,
  });

  final Query<Post> query;
  final String? appBarTitle;
  final PostsListType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatedPostQuery = ref.watch(postsRepositoryProvider).postsRef();
    final resetUpdatedDocIds =
        ref.watch(updatedPostIdsListProvider.notifier).removeAll;

    switch (type) {
      case PostsListType.small:
        return Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle ?? ''),
            automaticallyImplyLeading: kIsWeb ? false : true,
            leading: kIsWeb ? const WebBackButton() : null,
          ),
          body: SimplePageListView(
            query: query,
            listState: postsListStateProvider,
            itemBuilder: (context, index, doc) {
              final post = doc.data();
              return SmallPostsItem(
                post: post,
                index: index,
              );
            },
            refreshUpdatedDocs: true,
            updatedDocQuery: updatedPostQuery,
            resetUpdatedDocIds: resetUpdatedDocIds,
            updatedDocsState: updatedPostIdsListProvider,
          ),
        );
      case PostsListType.square:
        return Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle ?? ''),
            automaticallyImplyLeading: kIsWeb ? false : true,
            leading: kIsWeb ? const WebBackButton() : null,
          ),
          body: SimplePageListView(
            query: query,
            listState: postsListStateProvider,
            itemExtent: MediaQuery.sizeOf(context).width + cardBottomPadding,
            /*
                kIsWeb && MediaQuery.sizeOf(context).width > pcWidthBreakpoint
                    ? pcWidthBreakpoint + cardBottomPadding
                    : MediaQuery.sizeOf(context).width + cardBottomPadding,
                    */
            itemBuilder: (context, index, doc) {
              final post = doc.data();
              return BasicPostsItem(
                post: post,
                index: index,
              );
            },
            refreshUpdatedDocs: true,
            updatedDocQuery: updatedPostQuery,
            resetUpdatedDocIds: resetUpdatedDocIds,
            updatedDocsState: updatedPostIdsListProvider,
          ),
        );
      case PostsListType.page:
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(appBarTitle ?? ''),
            forceMaterialTransparency: true,
            foregroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: kIsWeb ? false : true,
            leading: kIsWeb ? const WebBackButton() : null,
          ),
          body: SimplePageListView(
            query: query,
            isPage: true,
            listState: postsListStateProvider,
            itemBuilder: (context, index, doc) {
              final post = doc.data();
              return BasicPostsItem(
                post: post,
                index: index,
                aspectRatio: MediaQuery.sizeOf(context).aspectRatio,
                isPage: true,
                // isTappable: false,
                showMainLabel: false,
              );
            },
            refreshUpdatedDocs: true,
            updatedDocQuery: updatedPostQuery,
            resetUpdatedDocIds: resetUpdatedDocIds,
            updatedDocsState: updatedPostIdsListProvider,
          ),
        );
    }
  }
}
