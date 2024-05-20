import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/features/admin_settings/domain/app_main_category.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_settings_screen_controller.g.dart';

@riverpod
class AdminSettingsScreenController extends _$AdminSettingsScreenController {
  // ignore: avoid_public_notifier_properties
  Object? key;
  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> saveAdminSettings({
    required String homeBarTitle,
    required int homeBarStyle,
    required Color mainColor,
    required List<MainCategory> mainCategory,
    XFile? xFile,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('user is null'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();

    final appUser = await ref.read(appUserFutureProvider(user.uid).future);
    if (appUser == null || !appUser.isAdmin) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }

    final key = this.key;
    final newState = await AsyncValue.guard(
      () => ref.read(adminSettingsServiceProvider).saveAdminSettings(
            homeBarTitle: homeBarTitle,
            homeBarStyle: homeBarStyle,
            mainColor: mainColor,
            mainCategory: mainCategory,
            xFile: xFile,
          ),
    );

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint(state.error.toString());
      return false;
    }

    try {
      await ref.read(adminSettingsServiceProvider).initialize();
    } catch (e) {
      debugPrint('adminSettings init error: ${e.toString()}');
    }

    ref.invalidate(adminSettingsProvider);

    return true;
  }
}
