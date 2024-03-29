import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostsFloatingActionButton extends ConsumerWidget {
  const PostsFloatingActionButton({super.key, this.heroTag});

  final Object? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        adminOnlyWrite ? ref.watch(authStateChangesProvider).value : null;
    final appUser =
        user != null ? ref.watch(appUserFutureProvider(user.uid)).value : null;
    return !adminOnlyWrite ||
            (adminOnlyWrite && appUser != null && appUser.isAdmin)
        ? FloatingActionButton(
            heroTag: heroTag,
            shape: const CircleBorder(),
            onPressed: () => context.push(ScreenPaths.write),
            // child: const Icon(Icons.add),
            child: const Icon(Icons.edit),
          )
        : const SizedBox.shrink();
  }
}
