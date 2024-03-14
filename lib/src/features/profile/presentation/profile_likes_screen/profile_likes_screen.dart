import 'package:applimode_app/src/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/basic_posts_item.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_list/posts_items/small_posts_item.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileLikesScreen extends StatelessWidget {
  const ProfileLikesScreen({
    super.key,
    required this.uid,
    this.type = PostsListType.square,
  });

  final String uid;
  final PostsListType type;

  @override
  Widget build(BuildContext context) {
    final isPage = type == PostsListType.page;
    final isSquare = type == PostsListType.square;
    return Scaffold(
      extendBodyBehindAppBar: isPage ? true : false,
      backgroundColor: isPage ? Colors.black : null,
      appBar: AppBar(
        automaticallyImplyLeading: kIsWeb ? false : true,
        leading: kIsWeb ? const WebBackButton() : null,
        title: Text(context.loc.likesPosts),
        forceMaterialTransparency: isPage ? true : false,
        foregroundColor: isPage ? Colors.white : null,
        elevation: isPage ? 0 : null,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final query =
              ref.watch(postLikesQueryProvider(uid: uid, isDislike: false));

          return isPage
              ? SimplePageListView(
                  query: query,
                  isPage: true,
                  listState: postsListStateProvider,
                  itemBuilder: (context, index, doc) {
                    final postLike = doc.data();
                    final postAsync =
                        ref.watch(postFutureProvider(postLike.postId));
                    return AsyncValueWidget(
                      value: postAsync,
                      data: (post) {
                        if (post == null) {
                          return const SizedBox.shrink();
                        }
                        return BasicPostsItem(
                          post: post,
                          index: index,
                          aspectRatio: MediaQuery.sizeOf(context).aspectRatio,
                          isPage: true,
                          // isTappable: false,
                          showMainLabel: false,
                        );
                      },
                    );
                  },
                )
              : SimplePageListView(
                  query: query,
                  listState: postsListStateProvider,
                  itemBuilder: (context, index, doc) {
                    final postLike = doc.data();
                    final postAsync =
                        ref.watch(postFutureProvider(postLike.postId));
                    return AsyncValueWidget(
                      value: postAsync,
                      data: (post) {
                        if (post == null) {
                          return const SizedBox.shrink();
                        }
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
                    );
                  },
                );
        },
      ),
    );
  }
}
