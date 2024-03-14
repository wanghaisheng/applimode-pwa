import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/simple_page_list_view.dart';
import 'package:applimode_app/src/common_widgets/user_items/user_item.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/comments/data/post_comment_likes_repository.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCommentLikesList extends ConsumerWidget {
  const PostCommentLikesList({
    super.key,
    required this.postCommentId,
    this.isDislike,
  });

  final String postCommentId;
  final bool? isDislike;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postCommentLikesQuery = ref.watch(postCommentLikesQueryProvider(
        commentId: postCommentId, isDislike: isDislike));
    return SafeArea(
      child: SimplePageListView(
        query: postCommentLikesQuery,
        listState: likesListStateProvider,
        itemBuilder: (context, index, doc) {
          final postCommentLike = doc.data();
          final likeUser = ref.watch(writerFutureProvider(postCommentLike.uid));
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
    return FirestoreListView<PostCommentLike>(
      query: postCommentLikesQuery,
      emptyBuilder: (context) => Center(
        child: Text(context.loc.noLike),
      ),
      errorBuilder: (context, error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      loadingBuilder: (context) =>
          const Center(child: CircularProgressIndicator.adaptive()),
      itemBuilder: (context, doc) {
        final postCommentLike = doc.data();
        final likeUser = ref.watch(writerFutureProvider(postCommentLike.uid));
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
