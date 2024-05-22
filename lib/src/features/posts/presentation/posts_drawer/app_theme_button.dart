import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppThemeButton extends ConsumerWidget {
  const AppThemeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(appSettingsControllerProvider).appThemeMode;
    final appThemeModeController =
        ref.watch(appSettingsControllerProvider.notifier);
    return MenuAnchor(
      style: const MenuStyle(
          padding:
              WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24))),
      builder: (context, controller, child) => ListTile(
        onTap: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            FocusScope.of(context).unfocus();
            controller.open();
          }
        },
        leading: const Icon(Icons.light_mode_outlined),
        title: Text(context.loc.appTheme),
        trailing: Text(
          appThemeMode == ThemeMode.light
              ? context.loc.lightThemeMode
              : appThemeMode == ThemeMode.dark
                  ? context.loc.darkThemeMode
                  : context.loc.systemThemeMode,
        ),
        leadingAndTrailingTextStyle: Theme.of(context).textTheme.labelLarge,
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            appThemeModeController.setAppThemeMode(ThemeMode.system);
          },
          child: Text(context.loc.systemThemeMode),
        ),
        MenuItemButton(
          onPressed: () {
            appThemeModeController.setAppThemeMode(ThemeMode.light);
          },
          child: Text(context.loc.lightThemeMode),
        ),
        MenuItemButton(
          onPressed: () {
            appThemeModeController.setAppThemeMode(ThemeMode.dark);
          },
          child: Text(context.loc.darkThemeMode),
        ),
      ],
    );
  }
}
