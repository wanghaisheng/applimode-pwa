import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/routing/app_router.dart';
import 'package:applimode_app/src/utils/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_service.g.dart';

class FCMService {
  const FCMService(this._ref, this._fcm);

  final Ref _ref;
  final FirebaseMessaging _fcm;

  Future<void> setupToken() async {
    await _fcm.requestPermission();

    final settings = await _fcm.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      setupSub();
      final token = await _fcm.getToken();
      if (token == null) {
        return;
      }
      final user = _ref.read(authRepositoryProvider).currentUser;
      if (user == null) {
        return;
      }
      final appUser = await _ref.read(appUserFutureProvider(user.uid).future);
      final sharedPreferences = _ref.read(sharedPreferencesProvider);
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
  }

  Future<void> setupSub() async {
    if (_ref.read(sharedPreferencesProvider).getBool('newPostNoti') ?? true) {
      debugPrint('subscribe');
      await _fcm.subscribeToTopic('newPost');
    } else {
      debugPrint('unsubscribe');
      await _fcm.unsubscribeFromTopic('newPost');
    }
  }

  Future<void> turnOnSub(String topic) => _fcm.subscribeToTopic(topic);
  Future<void> turnOffSub(String topic) => _fcm.unsubscribeFromTopic(topic);
  Future<void> tokenToEmpty(String uid) =>
      _ref.read(appUserRepositoryProvider).updateFcmToken(
            uid: uid,
            token: '',
          );

  Future<void> setupInteractedMessage() async {
    final initialMessage = await _fcm.getInitialMessage();

    if (initialMessage != null) {
      debugPrint('initailMessage exists');
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
