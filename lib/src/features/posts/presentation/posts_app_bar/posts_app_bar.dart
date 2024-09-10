import 'package:applimode_app/src/common_widgets/image_widgets/platform_network_image.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PostsAppBar({
    super.key,
    this.forceMaterialTransparency = false,
    this.foregroundColor,
    this.elevation,
    this.centerTitle,
  });

  final bool forceMaterialTransparency;
  final Color? foregroundColor;
  final double? elevation;
  final bool? centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(mainScreenAppBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminSettings = ref.watch(adminSettingsProvider);
    final homeBarStyle = adminSettings.homeBarStyle;
    final homeBarTitle = adminSettings.homeBarTitle;
    final homeBarImageUrl = adminSettings.homeBarImageUrl;
    final isMaintenance = adminSettings.isMaintenance;
    return AppBar(
      title: isMaintenance
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.loc.maintenanceTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  context.loc.maintenanceAccess,
                  style: Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (homeBarStyle == 1 || homeBarStyle == 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: mainScreenAppBarPadding),
                    child: SizedBox(
                      height:
                          mainScreenAppBarHeight - 2 * mainScreenAppBarPadding,
                      child: homeBarImageUrl.startsWith('assets')
                          ? Image.asset(homeBarImageUrl)
                          : PlatformNetworkImage(
                              imageUrl: homeBarImageUrl,
                              /*
                        cacheHeight: (mainScreenAppBarHeight -
                                2 * mainScreenAppBarPadding)
                            .round(),
                        */
                              errorWidget: const SizedBox.shrink(),
                            ),
                    ),
                  ),
                if (homeBarStyle == 2) const SizedBox(width: 8),
                if (homeBarStyle == 0 || homeBarStyle == 2) Text(homeBarTitle),
              ],
            ),
      forceMaterialTransparency: forceMaterialTransparency,
      foregroundColor: foregroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      actions: [
        /*
        IconButton(
          onPressed: () async {
            final result = context.canPop();
            debugPrint('canPop: $result');

            /*
            // 꼭 로그인하고 실행할 것
            final numList = List<int>.generate(25, (index) => index + 1);
            for (final i in numList) {
              final id = const Uuid().v7();
              await ref.read(postsRepositoryProvider).createTestPost(
                    id: id,
                    uid: ref.read(authRepositoryProvider).currentUser!.uid,
                    content: i.toString(),
                    category: Random().nextInt(4),
                    isRecommended: Random().nextBool(),
                    postCommentCount: Random().nextInt(100) + 20,
                    likeCount: Random().nextInt(100) + 20,
                    dislikeCount: Random().nextInt(100) + 20,
                    sumCount: Random().nextInt(100) + 20,
                  );
              print('$i Done');
            }
            print('finished');
            */
          },
          icon: const Icon(Icons.check_circle_outline_rounded),
        ),
        */
        if (showSearchButton)
          IconButton(
            onPressed: () => context.push(ScreenPaths.search),
            icon: const Icon(Icons.search),
          ),
      ],
    );
  }
}
