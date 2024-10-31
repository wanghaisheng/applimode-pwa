import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/admin_settings/application/admin_settings_service.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
FutureOr<void> appStartup(Ref ref) async {
  ref.onDispose(() {
    ref.invalidate(prefsWithCacheProvider);
  });
  await ref.watch(prefsWithCacheProvider.future);
  if (!useAdminSettingsInterval) {
    await ref.read(adminSettingsServiceProvider).fetch();
  }
  // When initializing multiple providers at the same time
  /*
  await Future.wait([
    ref.watch(prefsWithCacheProvider.future),
  ]);
  */
}
