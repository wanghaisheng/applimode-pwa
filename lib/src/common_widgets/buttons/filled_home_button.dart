import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilledHomeButton extends StatelessWidget {
  const FilledHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => context.go('/'),
      child: Text(context.loc.goHome),
    );
  }
}
