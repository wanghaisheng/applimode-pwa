import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool> showPasswordDialog(BuildContext context) async {
  return showReauthenticateDialog(
    context: context,
    providers: [EmailAuthProvider()],
    onSignedIn: () {
      context.pop(true);
    },
    actionButtonLabelOverride: context.loc.deleteAccount,
  );
}
