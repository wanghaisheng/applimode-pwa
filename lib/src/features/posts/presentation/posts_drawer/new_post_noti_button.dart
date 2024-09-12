import 'package:applimode_app/src/features/posts/presentation/posts_drawer/new_post_noti_button_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/utils/fcm_service.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';

class NewPostNotiButton extends ConsumerStatefulWidget {
  const NewPostNotiButton({super.key});

  @override
  ConsumerState<NewPostNotiButton> createState() => _NewPostNotiButtonState();
}

class _NewPostNotiButtonState extends ConsumerState<NewPostNotiButton> {
  @override
  Widget build(BuildContext context) {
    final sharedPreferences = ref.watch(prefsWithCacheProvider).requireValue;
    final authorized = ref.watch(authorizedByUserProvider);
    final isActivated = sharedPreferences.getBool('newPostNoti') != null;

    final isLoading = ref.watch(newPostNotiButtonControllerProvider).isLoading;

    return authorized.when(
      data: (authorized) => authorized && isActivated
          ? ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(context.loc.newPostNoti),
              trailing: isLoading
                  ? const CupertinoActivityIndicator()
                  : Switch(
                      value: sharedPreferences.getBool('newPostNoti')!,
                      onChanged: (value) async {
                        // sharedPreferences.setBool('newPostNoti', value);
                        if (value) {
                          final success = await ref
                              .read(
                                  newPostNotiButtonControllerProvider.notifier)
                              .turnOnSub('newPost');
                          if (success) {
                            sharedPreferences.setBool('newPostNoti', value);
                          }
                        } else {
                          final success = await ref
                              .read(
                                  newPostNotiButtonControllerProvider.notifier)
                              .turnOffSub('newPost');
                          if (success) {
                            sharedPreferences.setBool('newPostNoti', value);
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
