import 'dart:io';

import 'package:applimode_app/src/common_widgets/color_circle.dart';
import 'package:applimode_app/src/common_widgets/image_widgets/cached_circle_image.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/features/authentication/application/sign_out_service.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/app_locale_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/app_style_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/app_theme_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/like_comment_noti_button.dart';
import 'package:applimode_app/src/features/posts/presentation/posts_drawer/new_post_noti_button.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/remote_config_service.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostsDrawer extends ConsumerWidget {
  const PostsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Posts Drawer build');
    final user = ref.watch(authRepositoryProvider).currentUser;
    final appUser =
        user != null ? ref.watch(appUserFutureProvider(user.uid)).value : null;
    final categories = ref.watch(remoteConfigServiceProvider).mainCategory;
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            appUser == null
                ? ListTile(
                    leading: const Icon(Icons.face),
                    title: Text(context.loc.logIn),
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                      context.push(ScreenPaths.firebaseSignIn);
                    })
                : ListTile(
                    leading:
                        appUser.photoUrl == null || appUser.photoUrl!.isEmpty
                            ? const ColorCircle(
                                size: profileSizeSmall,
                              )
                            : CachedCircleImage(
                                imageUrl: appUser.photoUrl!,
                                size: profileSizeSmall,
                              ),
                    title: Text(
                      appUser.displayName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                      context.push(
                        ScreenPaths.account(appUser.uid),
                      );
                    },
                  ),
            divider24,
            /*
            ListTile(
              leading: const Icon(Icons.all_inclusive_outlined),
              title: Text(context.loc.allPosts),
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
            ),
            */
            if (useRecommendation)
              ListTile(
                leading: const Icon(Icons.recommend_outlined),
                title: Text(context.loc.recommendedPosts),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                  context.push(ScreenPaths.recommendedPosts);
                },
              ),
            if (useRanking)
              ListTile(
                leading: const Icon(Icons.military_tech_outlined),
                title: Text(context.loc.ranking),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  }
                  context.push(ScreenPaths.ranking);
                },
              ),
            if (categories.length > 1 && useCategory)
              ...categories.map(
                (e) => ListTile(
                  leading: Icon(
                    Icons.label_outline,
                    color: e.color,
                  ),
                  title: Text(e.title),
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                    context.push(e.path);
                  },
                ),
              ),
            if (useRecommendation ||
                useRanking ||
                useCategory ||
                showAppStyleOption)
              divider24,
            if (showAppStyleOption) const AppStyleButton(),
            const AppThemeButton(),
            const AppLocaleButton(),
            if (!kIsWeb &&
                useFcmMessage &&
                (Platform.isAndroid || Platform.isIOS && useApns)) ...[
              const NewPostNotiButton(),
              if (user != null) const LikeCommentNotiButton(),
            ],
            divider24,
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(context.loc.appInfo),
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
                context.push(ScreenPaths.appInfo);
              },
            ),
            divider24,
            if (user != null && showLogoutOnDrawer)
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.loc.logOut),
                onTap: () {
                  //ref.read(authRepositoryProvider).signOut();
                  ref.read(signOutServiceProvider).signOut();
                  if (context.canPop()) {
                    context.pop();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
