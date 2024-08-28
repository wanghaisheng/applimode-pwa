import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/common_widgets/sized_circular_progress_indicator.dart';
import 'package:applimode_app/src/features/authentication/presentation/firebase_sign_in_screen_controller.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/features/authentication/presentation/auth_providers.dart';
import 'package:applimode_app/src/utils/async_value_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class FirebaseSignInScreen extends ConsumerWidget {
  const FirebaseSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    final controller =
        ref.watch(firebaseSignInScreenControllerProvider.notifier);
    final controllerState = ref.watch(firebaseSignInScreenControllerProvider);

    ref.listen(firebaseSignInScreenControllerProvider, (_, state) {
      state.showAlertDialogOnError(context,
          content: context.loc.failedInitializing);
    });

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
        'invalid-credential' => context.loc.invalidCredential,
        _ => context.loc.unknownIssueWithAuth,
      };
    };
    return Scaffold(
      appBar: AppBar(),
      // appBar: AppBar(title: const Text('Welcome')),
      body: controllerState.isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedCircularProgressIndicator(),
                const SizedBox(height: 4),
                Text(
                  context.loc.initializing,
                  textAlign: TextAlign.center,
                ),
              ],
            ))
          : SignInScreen(
              providers: authProviders,
              styles: const {
                EmailFormStyle(signInButtonVariant: ButtonVariant.filled)
              },
              footerBuilder: (context, action) {
                if (action == AuthAction.signUp) {
                  final textTheme = Theme.of(context).textTheme.bodyMedium;
                  final linkStyle = textTheme?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 32,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(height: 1.5),
                              children: [
                                TextSpan(
                                  text: context.loc.argeeStart,
                                  style: textTheme,
                                ),
                                TextSpan(
                                  text: shortAppName,
                                  style: textTheme,
                                ),
                                TextSpan(
                                  text: ' ${context.loc.termsOfService} ',
                                  style: linkStyle,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (termsUrl.trim().isNotEmpty) {
                                        launchUrl(
                                          Uri.parse(termsUrl),
                                        );
                                      } else {
                                        context.push(ScreenPaths.appTerms);
                                      }
                                    },
                                ),
                                TextSpan(
                                  text: context.loc.argeeMiddle,
                                  style: textTheme,
                                ),
                                TextSpan(
                                  text: ' ${context.loc.privacyPolicy} ',
                                  style: linkStyle,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (privacyUrl.trim().isNotEmpty) {
                                        launchUrl(
                                          Uri.parse(privacyUrl),
                                        );
                                      } else {
                                        context.push(ScreenPaths.appPrivacy);
                                      }
                                    },
                                ),
                                TextSpan(
                                  text: context.loc.argeeEnd,
                                  style: textTheme,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              actions: [
                AuthStateChangeAction<SignedIn>(
                  (context, state) {
                    controller.initializeAppUsr();
                    // context.go(ScreenPaths.appUserCheck);
                  },
                ),
                AuthStateChangeAction<UserCreated>((context, state) {
                  controller.initializeAppUsr();
                  // context.go(ScreenPaths.appUserCheck);
                })
              ],
            ),
    );
  }
}
