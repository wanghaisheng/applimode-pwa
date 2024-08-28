import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/round_posts_item.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/basic_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePostsScreen extends ConsumerWidget {
  const ProfilePostsScreen({
    super.key,
    required this.uid,
    this.type = PostsListType.square,
  });

  final String uid;
  final PostsListType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPage = type == PostsListType.page;
    final isSmall = type == PostsListType.small;
    final isRound = type == PostsListType.round;
    final isMixed = type == PostsListType.mixed;

    final updatedPostQuery = ref.watch(postsRepositoryProvider).postsRef();
    final resetUpdatedDocIds =
        ref.watch(updatedPostIdsListProvider.notifier).removeAll;
    final query = ref.watch(postsRepositoryProvider).userPostsQuery(uid);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth > pcWidthBreakpoint
        ? ((screenWidth - pcWidthBreakpoint) / 2) + roundCardPadding
        : roundCardPadding;

    return Scaffold(
        extendBodyBehindAppBar: isPage ? true : false,
        backgroundColor: isPage ? Colors.black : null,
        appBar: AppBar(
          automaticallyImplyLeading: kIsWeb ? false : true,
          leading: kIsWeb ? const WebBackButton() : null,
          title: Text(context.loc.posts),
          forceMaterialTransparency: isPage ? true : false,
          foregroundColor: isPage ? Colors.white : null,
          elevation: isPage ? 0 : null,
        ),
        body: switch (type) {
          PostsListType.page => SimplePageListView(
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
          PostsListType.small ||
          PostsListType.square ||
          PostsListType.round ||
          PostsListType.mixed =>
            SimplePageListView(
              query: query,
              listState: postsListStateProvider,
              itemExtent: switch (type) {
                PostsListType.page => null,
                PostsListType.small => listSmallItemHeight,
                PostsListType.square =>
                  MediaQuery.sizeOf(context).width + cardBottomPadding,
                PostsListType.round =>
                  ((screenWidth - (2 * horizontalMargin)) * 9 / 16) +
                      roundCardPadding,
                PostsListType.mixed => null,
              },
              padding: switch (type) {
                PostsListType.page ||
                PostsListType.small ||
                PostsListType.square ||
                PostsListType.round =>
                  null,
                PostsListType.mixed =>
                  const EdgeInsets.only(bottom: roundCardPadding),
              },
              itemBuilder: (context, index, doc) {
                final post = doc.data();
                if (isSmall) {
                  return SmallPostsItem(
                    post: post,
                    index: index,
                  );
                }
                if (isRound) {
                  return RoundPostsItem(
                    post: post,
                    index: index,
                  );
                }
                if (isMixed) {
                  if (post.mainVideoUrl != null ||
                      (post.mainImageUrl != null &&
                          post.title.trim().isEmpty)) {
                    return RoundPostsItem(
                      post: post,
                      index: index,
                      needTopMargin: index == 0 ? false : true,
                      needBottomMargin: false,
                    );
                  }
                  return SmallPostsItem(
                    post: post,
                    index: index,
                  );
                }
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
        });
  }
}
