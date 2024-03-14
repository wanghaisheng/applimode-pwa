import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
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
    final sharedPreferences = ref.watch(sharedPreferencesProvider);
    return ListTile(
      leading: const Icon(Icons.notifications_outlined),
      title: Text(context.loc.likeCommentNoti),
      trailing: Switch(
          value: sharedPreferences.getBool('likeCommentNoti') ?? true,
          onChanged: (value) {
            sharedPreferences.setBool('likeCommentNoti', value);
            if (!value) {
              final user = ref.read(authRepositoryProvider).currentUser;
              if (user != null) {
                ref.read(fcmServiceProvider).tokenToEmpty(user.uid);
              }
            }
            setState(() {});
          }),
      leadingAndTrailingTextStyle: Theme.of(context).textTheme.labelLarge,
    );
  }
}
