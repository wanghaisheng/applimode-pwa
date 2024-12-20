import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:flutter/foundation.dart';
import 'package:applimode_app/src/common_widgets/async_value_widgets/async_value_widget.dart';
import 'package:applimode_app/src/common_widgets/user_items/writer_item.dart';
import 'package:applimode_app/src/common_widgets/web_back_button.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/presentation/post_app_bar_more.dart';
import 'package:applimode_app/src/features/post/presentation/post_screen_controller.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PostAppBar({
    super.key,
    required this.post,
    required this.writerAsync,
  });

  final Post post;
  final AsyncValue<AppUser?> writerAsync;

  @override
  Size get preferredSize => const Size.fromHeight(postScreenAppBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final appUser =
        user != null ? ref.watch(appUserStreamProvider(user.uid)).value : null;

    final isLoading = ref.watch(postScreenControllerProvider).isLoading;
    final useCategory = ref.watch(adminSettingsProvider).useCategory;

    return SliverAppBar(
      floating: true,
      centerTitle: false,
      toolbarHeight: postScreenAppBarHeight,
      automaticallyImplyLeading: kIsWeb ? false : true,
      leading: kIsWeb ? const WebBackButton() : null,
      title: AsyncValueWidget(
        value: writerAsync,
        data: (writer) {
          final isAppUser =
              writer != null && appUser != null && writer.uid == appUser.uid;
          return writer == null
              ? const SizedBox.shrink()
              : WriterItem(
                  writer: isAppUser ? appUser : writer,
                  post: post,
                  showSubtitle: true,
                  showMainCategory: useCategory,
                  profileImagesize: profileSizeBig,
                  nameColor: Theme.of(context).colorScheme.primary,
                  onTap: () => context.push(
                    ScreenPaths.profile(writer.uid),
                  ),
                );
        },
      ),
      actions: [
        if (writerAsync.value != null && user != null)
          IgnorePointer(
            ignoring: isLoading,
            child: PostAppBarMore(
              post: post,
              writerAsync: writerAsync,
            ),
          ),
      ],
    );
  }
}
