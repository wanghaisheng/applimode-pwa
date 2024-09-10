import 'dart:developer' as dev;

import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_service.g.dart';

bool isUsableFcm() {
  if (useFcmMessage) {
    // for web app like pwa
    // Currently not available in Safari on iOS and MacOS
    if (kIsWeb &&
        fcmVapidKey.trim().isNotEmpty &&
        !(defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      return true;
    }

    // for Android
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return true;
    }

    // for iOS
    if (useApns && !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return true;
    }
  }

  return false;

  /*
  return (kIsWeb && fcmVapidKey.trim().isNotEmpty) ||
      (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) ||
      (useApns && !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS);
  */
}

class FCMService {
  const FCMService(this._ref, this._fcm);

  final Ref _ref;
  final FirebaseMessaging _fcm;

  Future<void> setupToken() async {
    try {
      await _fcm.requestPermission();

      final settings = await _fcm.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
        final token = kIsWeb
            ? await _fcm.getToken(vapidKey: fcmVapidKey)
            : await _fcm.getToken();
        if (token == null) {
          return;
        }
        setupSub(token);
        final user = _ref.read(authRepositoryProvider).currentUser;
        if (user == null) {
          return;
        }
        final appUser = await _ref.read(appUserFutureProvider(user.uid).future);
        final sharedPreferences =
            _ref.read(prefsWithCacheProvider).requireValue;
        final isLikeComment = sharedPreferences.getBool('likeCommentNoti');
        if (appUser == null ||
            (appUser.fcmToken != null && appUser.fcmToken == token) ||
            (isLikeComment != null && !isLikeComment)) {
          return;
        }
        _ref.read(appUserRepositoryProvider).updateFcmToken(
              uid: user.uid,
              token: token,
            );
      }
    } catch (e) {
      debugPrint('setupTokenError: ${e.toString()}');
    }
  }

  Future<void> setupSub(String token) async {
    try {
      if (_ref
              .read(prefsWithCacheProvider)
              .requireValue
              .getBool('newPostNoti') ??
          true) {
        debugPrint('subscribe');
        if (kIsWeb) {
          FcmFunctions.callSubscribeToTopic(token: token, topic: 'newPost');
        } else {
          await _fcm.subscribeToTopic('newPost');
        }
      } else {
        debugPrint('unsubscribe');
        if (kIsWeb) {
          FcmFunctions.callUnsubscribeFromTopic(token: token, topic: 'newPost');
        } else {
          await _fcm.unsubscribeFromTopic('newPost');
        }
      }
    } catch (e) {
      debugPrint('setupSubError: ${e.toString()}');
    }
  }

  Future<void> turnOnSub(String topic) async {
    try {
      if (kIsWeb) {
        final token = await _fcm.getToken(vapidKey: fcmVapidKey);
        if (token != null) {
          FcmFunctions.callSubscribeToTopic(token: token, topic: 'newPost');
        }
      } else {
        _fcm.subscribeToTopic(topic);
      }
    } catch (e) {
      debugPrint('turnOnSubError: ${e.toString()}');
    }
  }

  Future<void> turnOffSub(String topic) async {
    try {
      if (kIsWeb) {
        final token = await _fcm.getToken(vapidKey: fcmVapidKey);
        if (token != null) {
          FcmFunctions.callUnsubscribeFromTopic(token: token, topic: 'newPost');
        }
      } else {
        _fcm.unsubscribeFromTopic(topic);
      }
    } catch (e) {
      debugPrint('turnOffSubError: ${e.toString()}');
    }
  }

  Future<void> tokenToEmpty(String uid) =>
      _ref.read(appUserRepositoryProvider).updateFcmToken(
            uid: uid,
            token: '',
          );

  Future<void> setupInteractedMessage() async {
    final initialMessage = await _fcm.getInitialMessage();

    if (initialMessage != null) {
      dev.log('initailMessage exists');
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final type = message.data['type'] as String?;
    final postId = message.data['postId'] as String?;
    final commentId = message.data['commentId'] as String?;
    final goRouter = _ref.read(goRouterProvider);
    if (type == 'post' && postId != null) {
      goRouter.push(ScreenPaths.post(postId));
    } else if (type == 'comments' && postId != null) {
      goRouter.push(ScreenPaths.comments(postId));
    } else if (type == 'replies' && postId != null && commentId != null) {
      goRouter.push(ScreenPaths.replies(postId, commentId));
    } else if (type == 'commentLikes' && postId != null) {
      goRouter.push(ScreenPaths.comments(postId));
    } else if (type == 'postLikes' && postId != null) {
      goRouter.push(ScreenPaths.post(postId));
    }
  }
}

@riverpod
FCMService fcmService(FcmServiceRef ref) {
  return FCMService(ref, FirebaseMessaging.instance);
}
