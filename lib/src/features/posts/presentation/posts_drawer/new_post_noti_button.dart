import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
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
    return ListTile(
      leading: const Icon(Icons.notifications_outlined),
      title: Text(context.loc.newPostNoti),
      trailing: Switch(
          value: sharedPreferences.getBool('newPostNoti') ?? true,
          onChanged: (value) {
            sharedPreferences.setBool('newPostNoti', value);
            if (value) {
              ref.read(fcmServiceProvider).turnOnSub('newPost');
            } else {
              ref.read(fcmServiceProvider).turnOffSub('newPost');
            }
            setState(() {});
          }),
      leadingAndTrailingTextStyle: Theme.of(context).textTheme.labelLarge,
    );
  }
}
