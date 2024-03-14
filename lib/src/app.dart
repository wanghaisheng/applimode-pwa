import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/app_settings/app_settings_controller.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/themes/app_theme_data.dart';
import 'package:applimode_app/src/utils/fcm_service.dart';
import 'package:applimode_app/src/utils/remote_config_service.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('MaterialApp build');

    if (!kIsWeb && useFcmMessage) {
      if (Platform.isAndroid || Platform.isIOS && useApns) {
        final fcmService = ref.watch(fcmServiceProvider);
        fcmService.setupToken();
        fcmService.setupInteractedMessage();
      }
    }

    final goRouter = ref.watch(goRouterProvider);
    final mainColor = ref.watch(remoteConfigServiceProvider).mainColor;
    final appSettings = ref.watch(appSettingsControllerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      localizationsDelegates: [
        AppLocalizations.delegate,
        FirebaseUILocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: appSettings.appLocale,
      themeMode: appSettings.appThemeMode,
      theme: AppThemeData.themeData(
        brightness: Brightness.light,
        colorSchemeSeed: mainColor,
      ),
      darkTheme: AppThemeData.themeData(
        brightness: Brightness.dark,
        colorSchemeSeed: mainColor,
      ),
    );
  }
}

// old version
/*
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      setupToken();
    }
    setupInteractedMessage();
  }

  Future<void> setupToken() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    final settings = await fcm.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      if (ref.read(sharedPreferencesProvider).getBool('newPostNoti') ?? true) {
        debugPrint('subscribe');
        await FirebaseMessaging.instance.subscribeToTopic('newPost');
      } else {
        debugPrint('unsubscribe');
        await FirebaseMessaging.instance.unsubscribeFromTopic('newPost');
      }
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        return;
      }
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) {
        return;
      }
      final appUser = await ref.read(appUserFutureProvider(user.uid).future);
      if (appUser == null ||
          (appUser.fcmToken != null && appUser.fcmToken == token)) {
        return;
      }
      ref.read(appUserRepositoryProvider).updateFcmToken(
            uid: user.uid,
            token: token,
          );
    }
  }

  Future<void> setupInteractedMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('initailMessage exists');
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final goRouter = ref.read(goRouterProvider);
    if (message.data['type'] == 'post' && message.data['postId'] != null) {
      goRouter.push(ScreenPaths.post(message.data['postId']));
    } else if (message.data['type'] == 'comments' &&
        message.data['postId'] != null) {
      goRouter.push(ScreenPaths.comments(message.data['postId']));
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MaterialApp build');
    final goRouter = ref.watch(goRouterProvider);
    final mainColor = ref.watch(remoteConfigServiceProvider).mainColor;
    final appSettings = ref.watch(appSettingsControllerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      localizationsDelegates: [
        AppLocalizations.delegate,
        FirebaseUILocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: appSettings.appLocale,
      themeMode: appSettings.appThemeMode,
      theme: AppThemeData.themeData(
        brightness: Brightness.light,
        colorSchemeSeed: mainColor,
      ),
      darkTheme: AppThemeData.themeData(
        brightness: Brightness.dark,
        colorSchemeSeed: mainColor,
      ),
    );
  }
}
*/
