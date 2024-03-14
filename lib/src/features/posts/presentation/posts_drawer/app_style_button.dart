import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/constants/constants.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStyleButton extends ConsumerWidget {
  const AppStyleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStyle = ref.watch(appSettingsControllerProvider).appStyle;
    final appStyleController =
        ref.watch(appSettingsControllerProvider.notifier);
    return MenuAnchor(
      style: const MenuStyle(
          padding:
              MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 24))),
      builder: (context, controller, child) => ListTile(
        onTap: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            FocusScope.of(context).unfocus();
            controller.open();
          }
        },
        leading: const Icon(Icons.space_dashboard_outlined),
        title: Text(context.loc.appStyle),
        trailing: Text(getTrailingLabel(context, appStyle ?? 1)),
        leadingAndTrailingTextStyle: Theme.of(context).textTheme.labelLarge,
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            appStyleController.setAppStyle(PostsListType.small);
          },
          child: Text(context.loc.listType),
        ),
        MenuItemButton(
          onPressed: () {
            appStyleController.setAppStyle(PostsListType.square);
          },
          child: Text(context.loc.cardType),
        ),
        MenuItemButton(
          onPressed: () {
            appStyleController.setAppStyle(PostsListType.page);
          },
          child: Text(context.loc.pageType),
        ),
      ],
    );
  }

  String getTrailingLabel(BuildContext context, int index) {
    switch (index) {
      case 0:
        return context.loc.listType;
      case 1:
        return context.loc.cardType;
      case 2:
        return context.loc.pageType;
      default:
        return context.loc.cardType;
    }
  }
}
