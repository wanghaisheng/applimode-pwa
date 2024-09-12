import 'package:applimode_app/src/features/posts/presentation/posts_drawer/like_comment_noti_button_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/fcm_service.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';

class LikeCommentNotiButton extends ConsumerStatefulWidget {
  const LikeCommentNotiButton({super.key});

  @override
  ConsumerState<LikeCommentNotiButton> createState() =>
      _LikeCommentNotiButtonState();
}

class _LikeCommentNotiButtonState extends ConsumerState<LikeCommentNotiButton> {
  @override
  Widget build(BuildContext context) {
    final sharedPreferences = ref.watch(prefsWithCacheProvider).requireValue;
    final authorized = ref.watch(authorizedByUserProvider);
    final isActivated = sharedPreferences.getBool('likeCommentNoti') != null;

    final isLoading =
        ref.watch(likeCommentNotiButtonControllerProvider).isLoading;

    return authorized.when(
      data: (authorized) => authorized && isActivated
          ? ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(context.loc.likeCommentNoti),
              trailing: isLoading
                  ? const CupertinoActivityIndicator()
                  : Switch(
                      value: sharedPreferences.getBool('likeCommentNoti')!,
                      onChanged: (value) async {
                        if (value) {
                          final success = await ref
                              .read(likeCommentNotiButtonControllerProvider
                                  .notifier)
                              .updateToken();
                          if (success) {
                            sharedPreferences.setBool('likeCommentNoti', value);
                          }
                        } else {
                          final success = await ref
                              .read(likeCommentNotiButtonControllerProvider
                                  .notifier)
                              .tokenToEmpty();
                          if (success) {
                            sharedPreferences.setBool('likeCommentNoti', value);
                          }
                        }
                        setState(() {});
                      }),
              leadingAndTrailingTextStyle:
                  Theme.of(context).textTheme.labelLarge,
            )
          : const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
