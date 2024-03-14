import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/presentation/post_screen_controller.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/features/posts/domain/post_and_writer.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:applimode_app/src/utils/web_back/web_back_stub.dart';

class PostAppBarMore extends ConsumerWidget {
  const PostAppBarMore({
    super.key,
    required this.postId,
    // this.postAndWriter,
    required this.postAsync,
    required this.writerAsync,
  });

  final String postId;
  // final PostAndWriter? postAndWriter;
  final AsyncValue<Post?> postAsync;
  final AsyncValue<AppUser?> writerAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser!;
    final appUser = ref.watch(appUserFutureProvider(user.uid));
    final postAndWriter =
        PostAndWriter(post: postAsync.value!, writer: writerAsync.value!);
    return AsyncValueWidget(
      value: appUser,
      data: (appUser) {
        return PopupMenuButton(
          tooltip: 'Edit or delete post',
          position: PopupMenuPosition.under,
          itemBuilder: (context) {
            return [
              if (user.uid == writerAsync.value?.uid)
                PopupMenuItem(
                  onTap: () {
                    context.push(
                      ScreenPaths.edit(postId),
                      extra: postAndWriter,
                    );
                  },
                  child: Text(context.loc.editPost),
                ),
              if (appUser != null && appUser.isAdmin == true) ...[
                if (useRecommendation)
                  PopupMenuItem(
                    onTap: () async {
                      final result = postAsync.value?.isRecommended ?? false
                          ? await ref
                              .read(postScreenControllerProvider.notifier)
                              .unrecommendPost(
                                postId: postId,
                                isAdmin: appUser.isAdmin,
                              )
                          : await ref
                              .read(postScreenControllerProvider.notifier)
                              .recommendPost(
                                postId: postId,
                                isAdmin: appUser.isAdmin,
                              );
                      if (context.mounted && result) {
                        if (kIsWeb) {
                          WebBackStub().back();
                        } else {
                          if (context.canPop()) {
                            context.pop();
                          }
                        }
                      }
                    },
                    child: Text(
                      postAsync.value?.isRecommended ?? false
                          ? context.loc.unrecommendPost
                          : context.loc.recommendPost,
                    ),
                  ),
                PopupMenuItem(
                  onTap: () async {
                    final result = postAsync.value?.isHeader ?? false
                        ? await ref
                            .read(postScreenControllerProvider.notifier)
                            .toGeneralPost(
                              postId: postId,
                              isAdmin: appUser.isAdmin,
                            )
                        : await ref
                            .read(postScreenControllerProvider.notifier)
                            .toMainPost(
                              postId: postId,
                              isAdmin: appUser.isAdmin,
                            );
                    if (context.mounted && result) {
                      if (kIsWeb) {
                        WebBackStub().back();
                      } else {
                        if (context.canPop()) {
                          context.pop();
                        }
                      }
                    }
                  },
                  child: Text(
                    postAsync.value?.isHeader ?? false
                        ? context.loc.specifyGeneralPost
                        : context.loc.specifyMainPost,
                  ),
                ),
                PopupMenuItem(
                  onTap: () async {
                    final result = postAsync.value?.isBlock ?? false
                        ? await ref
                            .read(postScreenControllerProvider.notifier)
                            .unblockPost(
                              postId: postId,
                              isAdmin: appUser.isAdmin,
                            )
                        : await ref
                            .read(postScreenControllerProvider.notifier)
                            .blockPost(
                              postId: postId,
                              isAdmin: appUser.isAdmin,
                            );
                    if (context.mounted && result) {
                      if (kIsWeb) {
                        WebBackStub().back();
                      } else {
                        if (context.canPop()) {
                          context.pop();
                        }
                      }
                    }
                  },
                  child: Text(
                    postAsync.value?.isBlock ?? false
                        ? context.loc.unblockPost
                        : context.loc.blockPost,
                  ),
                ),
              ],
              if (user.uid == writerAsync.value?.uid ||
                  appUser != null && appUser.isAdmin == true)
                PopupMenuItem(
                  onTap: () async {
                    final result = await ref
                        .read(postScreenControllerProvider.notifier)
                        .deletePost(
                          postId: postId,
                          post: postAsync.value!,
                          isAdmin: appUser?.isAdmin ?? false,
                        );
                    if (context.mounted && result) {
                      if (kIsWeb) {
                        WebBackStub().back();
                      } else {
                        if (context.canPop()) {
                          context.pop();
                        }
                      }
                    }
                  },
                  child: Text(context.loc.deletePost),
                ),
            ];
          },
        );
      },
    );
  }
}
