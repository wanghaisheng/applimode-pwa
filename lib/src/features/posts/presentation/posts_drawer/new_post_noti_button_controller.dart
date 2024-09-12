import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:applimode_app/src/utils/fcm_service.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_post_noti_button_controller.g.dart';

@riverpod
class NewPostNotiButtonController extends _$NewPostNotiButtonController {
  // ignore: avoid_public_notifier_properties
  Object? key;

  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> turnOnSub(String topic) async {
    state = const AsyncLoading();
    final fcmService = ref.read(fcmServiceProvider);
    final token = await fcmService.fcmToken;

    if (token == null) {
      state = AsyncError(Exception('token error'), StackTrace.current);
      return false;
    }

    final key = this.key;

    final newState = await AsyncValue.guard(() async {
      if (kIsWeb) {
        await FcmFunctions.callSubscribeToTopic(token: token, topic: topic);
      } else {
        await fcmService.subToTopic(topic);
      }
    });

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('turnOnSub error: ${state.error.toString()}');
      return false;
    }
    return true;
  }

  Future<bool> turnOffSub(String topic) async {
    state = const AsyncLoading();
    final fcmService = ref.read(fcmServiceProvider);
    final token = await fcmService.fcmToken;

    if (token == null) {
      state = AsyncError(Exception('token error'), StackTrace.current);
      return false;
    }

    final key = this.key;
    final newState = await AsyncValue.guard(() async {
      if (kIsWeb) {
        await FcmFunctions.callUnsubscribeFromTopic(token: token, topic: topic);
      } else {
        await fcmService.unsubFromTopic(topic);
      }
    });

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('turnOffSub error: ${state.error.toString()}');
      return false;
    }
    return true;
  }
}
