import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/user_items/user_item.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostLikesList extends ConsumerWidget {
  const PostLikesList({
    super.key,
    required this.postId,
    this.isDislike,
  });

  final String postId;
  final bool? isDislike;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postLikesQuery =
        ref.watch(postLikesQueryProvider(postId: postId, isDislike: isDislike));

    return SafeArea(
      top: false,
      bottom: false,
      child: SimplePageListView(
        query: postLikesQuery,
        listState: likesListStateProvider,
        isNoGridView: true,
        itemBuilder: (context, index, doc) {
          final postLike = doc.data();
          final likeUser = ref.watch(writerFutureProvider(postLike.uid));
          return AsyncValueWidget(
            value: likeUser,
            data: (likeUser) {
              if (likeUser == null) {
                return const SizedBox.shrink();
              }
              return UserItem(
                appUser: likeUser,
                profileImageSize: profileSizeBig,
                index: index,
              );
            },
          );
        },
      ),
    );
    /*
    return FirestoreListView<PostLike>(
      query: postLikesQuery,
      emptyBuilder: (context) => Center(
        child: Text(context.loc.noLike),
      ),
      errorBuilder: (context, error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      loadingBuilder: (context) =>
          const Center(child: CircularProgressIndicator.adaptive()),
      itemBuilder: (context, doc) {
        final postLike = doc.data();
        final likeUser = ref.watch(writerFutureProvider(postLike.uid));
        return AsyncValueWidget(
          value: likeUser,
          data: (likeUser) {
            if (likeUser == null) {
              return const SizedBox.shrink();
            }
            return UserItem(
              appUser: likeUser,
              profileImageSize: profileSizeBig,
            );
          },
        );
      },
    );
    */
  }
}
