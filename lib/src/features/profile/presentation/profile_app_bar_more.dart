import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/profile/presentation/profile_app_bar_more_controller.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:applimode_app/src/utils/show_image_picker.dart';
import 'package:applimode_app/src/utils/show_selection_dialog.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileAppBarMore extends ConsumerWidget {
  const ProfileAppBarMore({
    super.key,
    required this.appUser,
    required this.user,
    this.color,
  });

  final AppUser appUser;
  final User user;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profileAppBarMoreControllerProvider, (_, next) {
      next.showAlertDialogOnError(context);
    });
    final isLoading = ref.watch(profileAppBarMoreControllerProvider).isLoading;

    return /* isLoading
        ? Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedCircularProgressIndicator(
              backgroundColor: color,
            ),
          )
        :*/
        IgnorePointer(
      ignoring: isLoading,
      child: PopupMenuButton(
        tooltip: 'Edit profile',
        icon: Icon(
          Icons.more_vert,
          color: color,
        ),
        //color: color,
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              onTap: () {
                context.push(
                  ScreenPaths.editUsername(
                    appUser.uid,
                    appUser.displayName,
                  ),
                );
              },
              child: Text(context.loc.editUsername),
            ),
            PopupMenuItem(
              onTap: () {
                showSelectionDialog(
                  context: context,
                  firstTitle: context.loc.defaultImage,
                  firstTap: () async {
                    context.pop();
                    await ref
                        .read(profileAppBarMoreControllerProvider.notifier)
                        .changeProfileImage(null);
                  },
                  secondTitle: context.loc.chooseFromGallery,
                  secondTap: () async {
                    context.pop();
                    final xFile = await showImagePicker();
                    if (xFile != null) {
                      await ref
                          .read(profileAppBarMoreControllerProvider.notifier)
                          .changeProfileImage(xFile);
                    }
                  },
                );
              },
              child: Text(context.loc.changeProfileImage),
            ),
            if (user.email != null)
              PopupMenuItem(
                onTap: () {
                  showSelectionDialog(
                    context: context,
                    firstTitle: context.loc.defaultImage,
                    firstTap: () async {
                      context.pop();
                      await ref
                          .read(profileAppBarMoreControllerProvider.notifier)
                          .changeStoryImage(null);
                    },
                    secondTitle: context.loc.chooseFromGallery,
                    secondTap: () async {
                      context.pop();
                      final xFile = await showImagePicker();
                      if (xFile != null) {
                        await ref
                            .read(profileAppBarMoreControllerProvider.notifier)
                            .changeStoryImage(xFile);
                      }
                    },
                  );
                },
                child: Text(context.loc.changeStoryImage),
              ),
            PopupMenuItem(
              onTap: () {
                context.push(
                  ScreenPaths.editBio(
                    appUser.uid,
                    appUser.bio.trim().isEmpty ? noBio : appUser.bio,
                  ),
                );
              },
              child: Text(context.loc.editBio),
            ),
            /*
                  PopupMenuItem(
                    onTap: () {
                      context.push(
                        ScreenPaths.changeEmail(appUser.uid, user.email!),
                      );
                    },
                    child: Text(context.loc.changeEmail),
                  ),
                  */
            PopupMenuItem(
              onTap: () {
                context.push(
                  ScreenPaths.changePassword(appUser.uid),
                );
              },
              child: Text(context.loc.changePassword),
            ),
          ];
        },
      ),
    );
  }
}
