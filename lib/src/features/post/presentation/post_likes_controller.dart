import 'package:applimode_app/custom_settings.dart';
import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/post/application/post_likes_service.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/utils/call_fcm_function.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:applimode_app/src/utils/updated_user_ids_list.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'post_likes_controller.g.dart';

@riverpod
class PostLikesController extends _$PostLikesController {
// ignore: avoid_public_notifier_properties
  Object? key;
  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> increasePostLikeCount({
    required String postId,
    required String writerId,
    AppUser? postWriter,
    required String postLikeNotiString,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('user is null'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final id = const Uuid().v7();
    final newState = await AsyncValue.guard(
      () => PostLikesService(ref).increasePostLikeCount(
        id: id,
        uid: user.uid,
        postId: postId,
        writerId: writerId,
      ),
    );
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint(state.error.toString());
      return false;
    }

    if (useFcmMessage) {
      try {
        postWriter ??= await ref.read(appUserFutureProvider(writerId).future);

        if (postWriter != null &&
            postWriter.fcmToken != null &&
            postWriter.fcmToken!.isNotEmpty) {
          callFcmFunction(
            functionName: 'sendFcmMessage',
            type: 'postLikes',
            content: '${user.displayName ?? 'Unknown'} $postLikeNotiString',
            postId: postId,
            token: postWriter.fcmToken,
          );
        }
      } catch (e) {
        debugPrint('fcmError: $e');
      }
    }

    ref.read(updatedPostIdsListProvider.notifier).set(postId);
    ref.read(updatedUserIdsListProvider.notifier).set(writerId);
    ref.invalidate(writerFutureProvider);

    ref.invalidate(postLikesByUserFutureProvider);
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    return true;
  }

  Future<bool> decreasePostLikeCount({
    required String id,
    required String postId,
    required String writerId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('user is null'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(
      () => PostLikesService(ref).decreasePostLikeCount(
        id: id,
        postId: postId,
        writerId: writerId,
      ),
    );

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint(state.error.toString());
      return false;
    }

    ref.read(updatedPostIdsListProvider.notifier).set(postId);
    ref.read(updatedUserIdsListProvider.notifier).set(writerId);
    ref.invalidate(writerFutureProvider);

    ref.invalidate(postLikesByUserFutureProvider);
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    return true;
  }

  Future<bool> increasePostDislikeCount({
    required String postId,
    required String writerId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('user is null'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final id = const Uuid().v7();
    final newState = await AsyncValue.guard(
      () => PostLikesService(ref).increasePostDislikeCount(
        id: id,
        uid: user.uid,
        postId: postId,
        writerId: writerId,
      ),
    );

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint(state.error.toString());
      return false;
    }

    ref.read(updatedPostIdsListProvider.notifier).set(postId);
    ref.read(updatedUserIdsListProvider.notifier).set(writerId);
    ref.invalidate(writerFutureProvider);

    ref.invalidate(postLikesByUserFutureProvider);
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    return true;
  }

  Future<bool> decreasePostDislikeCount({
    required String id,
    required String postId,
    required String writerId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = AsyncError(Exception('user is null'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(
      () => PostLikesService(ref)
          .decreasePostDislikeCount(id: id, postId: postId, writerId: writerId),
    );

    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint(state.error.toString());
      return false;
    }

    ref.read(updatedPostIdsListProvider.notifier).set(postId);
    ref.read(updatedUserIdsListProvider.notifier).set(writerId);
    ref.invalidate(writerFutureProvider);

    ref.invalidate(postLikesByUserFutureProvider);
    ref.read(likesListStateProvider.notifier).set(nowToInt());

    return true;
  }
}
