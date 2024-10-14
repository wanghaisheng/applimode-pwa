import 'dart:async';

import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/basic_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/round_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPostsList extends ConsumerStatefulWidget {
  const MainPostsList({
    super.key,
    this.type = PostsListType.square,
  });

  final PostsListType type;

  @override
  ConsumerState<MainPostsList> createState() => _MainPostsListState();
}

class _MainPostsListState extends ConsumerState<MainPostsList> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: mainPostsRefreshTimer), () {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget _startPostBuilder(BuildContext context) =>
      Center(child: Text(context.loc.startFirstPost));

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(postsRepositoryProvider).defaultPostsQuery();
    final mainQuery = ref.watch(postsRepositoryProvider).mainPostsQuery();
    final recentDocQuery = ref.watch(postsRepositoryProvider).recentPostQuery();
    final updatedPostQuery = ref.watch(postsRepositoryProvider).postsRef();
    final resetUpdatedDocIds =
        ref.watch(updatedPostIdsListProvider.notifier).removeAll;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    return RefreshIndicator(
      onRefresh: () async {
        if (timer != null && timer!.isActive) {
          return;
        }
        ref.read(postsListStateProvider.notifier).set(nowToInt());
        timer = Timer(const Duration(seconds: mainPostsRefreshTimer), () {});
      },
      child: switch (widget.type) {
        // small type
        PostsListType.small => SimplePageListView<Post>(
            query: query,
            recentDocQuery: recentDocQuery,
            showMain: true,
            mainQuery: mainQuery,
            listState: postsListStateProvider,
            emptyBuilder: _startPostBuilder,
            itemBuilder: (context, index, doc) {
              final post = doc.data();
              if (index == 0 && post.isHeader) {
                return RoundPostsItem(
                  post: post,
                  aspectRatio: smallItemHeaderRatio,
                  index: index,
                );
              }
              return SmallPostsItem(
                post: post,
                index: index,
              );
            },
            refreshUpdatedDocs: true,
            updatedDocQuery: updatedPostQuery,
            isRootTabel: true,
            resetUpdatedDocIds: resetUpdatedDocIds,
            updatedDocsState: updatedPostIdsListProvider,
          ),
        // square type
        PostsListType.square => SimplePageListView<Post>(
            query: query,
            recentDocQuery: recentDocQuery,
            showMain: true,
            mainQuery: mainQuery,
            listState: postsListStateProvider,
            itemExtent: MediaQuery.sizeOf(context).width + cardBottomPadding,
            emptyBuilder: _startPostBuilder,
            itemBuilder: (context, index, doc) {
              final post = doc.data();
              return BasicPostsItem(
                post: post,
                index: index,
              );
            },
            refreshUpdatedDocs: true,
            updatedDocQuery: updatedPostQuery,
            isRootTabel: true,
            resetUpdatedDocIds: resetUpdatedDocIds,
            updatedDocsState: updatedPostIdsListProvider,
          ),
        // page type
        PostsListType.page => SimplePageListView<Post>(
            query: query,
            isPage: true,
            recentDocQuery: recentDocQuery,
            showMain: true,
            allowImplicitScrolling: true,
            mainQuery: mainQuery,
            listState: postsListStateProvider,
            emptyBuilder: _startPostBuilder,
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
            isRootTabel: true,
            resetUpdatedDocIds: resetUpdatedDocIds,
            updatedDocsState: updatedPostIdsListProvider,
          ),
        PostsListType.round => SimplePageListView<Post>(
            query: query,
            recentDocQuery: recentDocQuery,
            showMain: true,
            mainQuery: mainQuery,
            listState: postsListStateProvider,
            itemExtent: ((screenWidth - (2 * horizontalMargin)) * 9 / 16) +
                roundCardPadding,
            emptyBuilder: _startPostBuilder,
            itemBuilder: (context, index, doc) {
              final post = doc.data();
              return RoundPostsItem(
                post: post,
                index: index,
              );
            },
            refreshUpdatedDocs: true,
            updatedDocQuery: updatedPostQuery,
            isRootTabel: true,
            resetUpdatedDocIds: resetUpdatedDocIds,
            updatedDocsState: updatedPostIdsListProvider,
          ),
        PostsListType.mixed => SimplePageListView<Post>(
            query: query,
            recentDocQuery: recentDocQuery,
            showMain: true,
            mainQuery: mainQuery,
            listState: postsListStateProvider,
            padding: const EdgeInsets.only(bottom: roundCardPadding),
            emptyBuilder: _startPostBuilder,
            itemBuilder: (context, index, doc) {
              final post = doc.data();
              if (index == 0 && post.isHeader) {
                return RoundPostsItem(
                  post: post,
                  aspectRatio: smallItemHeaderRatio,
                  index: index,
                  needBottomMargin: false,
                );
              }
              if (post.mainVideoUrl != null ||
                  (post.mainImageUrl != null && post.title.trim().isEmpty)) {
                return RoundPostsItem(
                  post: post,
                  index: index,
                  needTopMargin: true,
                  needBottomMargin: false,
                );
              }
              return SmallPostsItem(
                post: post,
                index: index,
              );
            },
            refreshUpdatedDocs: true,
            updatedDocQuery: updatedPostQuery,
            isRootTabel: true,
            resetUpdatedDocIds: resetUpdatedDocIds,
            updatedDocsState: updatedPostIdsListProvider,
          ),
      },
    );
  }
}
