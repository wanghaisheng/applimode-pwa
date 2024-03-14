import 'package:applimode_app/src/constants/constants.dart';
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
    final isSquare = type == PostsListType.square;

    final updatedPostQuery = ref.watch(postsRepositoryProvider).postsRef();
    final resetUpdatedDocIds =
        ref.watch(updatedPostIdsListProvider.notifier).removeAll;
    final query = ref.watch(postsRepositoryProvider).userPostsQuery(uid);

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
      body: isPage
          ? SimplePageListView(
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
            )
          : SimplePageListView(
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
                if (isSquare) {
                  return BasicPostsItem(
                    post: post,
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
              resetUpdatedDocIds: resetUpdatedDocIds,
              updatedDocsState: updatedPostIdsListProvider,
            ),
    );
  }
}
