import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilledBackButton extends StatelessWidget {
  const FilledBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        }
      },
      child: Text(context.loc.goBack),
    );
  }
}
