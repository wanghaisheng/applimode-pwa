import 'dart:math';

import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_user_check_service.g.dart';

class AppUserCheckService {
  const AppUserCheckService(this._ref);

  final Ref _ref;

  Future<void> initializeAppUser(String uid) async {
    final initialId = (Random().nextInt(999999) + 1).toString();
    // final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    final displayName = 'User$initialId';
    await _ref
        .read(authRepositoryProvider)
        .updateMetadata(displayName: displayName);
    await _ref.read(appUserRepositoryProvider).createAppUser(
          uid: uid,
          displayName: displayName,
          isAdmin: false,
          isBlock: false,
          isHideInfo: false,
          bio: '',
          gender: 0,
          likeCount: 0,
          dislikeCount: 0,
          sumCount: 0,
          verified: false,
        );
  }
}

@riverpod
AppUserCheckService appUserCheckService(AppUserCheckServiceRef ref) {
  return AppUserCheckService(ref);
}
