import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FirebasePhoneScreen extends ConsumerWidget {
  const FirebasePhoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ErrorText.localizeError = (BuildContext context, FirebaseAuthException e) {
      debugPrint(e.code);
      return switch (e.code) {
        'invalid-email' => context.loc.invalidEmail,
        'email-already-in-use' => context.loc.emailAlreadyInUse,
        'weak-password' => context.loc.weakPassword,
        'user-disabled' => context.loc.userDisabled,
        'user-not-found' => context.loc.userNotFound,
        'credential-already-in-use' => context.loc.emailAlreadyInUse,
        'wrong-password' => context.loc.wrongPassword,
        'invalid-login-credentials' => context.loc.invalidLoginCredentials,
        _ => context.loc.unknownIssueWithAuth,
      };
    };
    return PhoneInputScreen(
      actions: [
        AuthStateChangeAction<SignedIn>(
          (context, state) {
            context.go(ScreenPaths.appUserCheck);
          },
        ),
        AuthStateChangeAction<UserCreated>((context, state) {
          context.go(ScreenPaths.appUserCheck);
        }),
        SMSCodeRequestedAction((context, action, flowKey, phoneNumber) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SMSCodeInputScreen(
                flowKey: flowKey,
                actions: [
                  AuthStateChangeAction<SignedIn>(
                    (context, state) {
                      context.go(ScreenPaths.appUserCheck);
                    },
                  ),
                  AuthStateChangeAction<UserCreated>((context, state) {
                    context.go(ScreenPaths.appUserCheck);
                  }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
