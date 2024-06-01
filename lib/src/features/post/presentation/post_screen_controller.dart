import 'package:applimode_app/src/features/authentication/data/auth_repository.dart';
import 'package:applimode_app/src/features/post/application/post_delete_service.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';
import 'package:applimode_app/src/utils/list_state.dart';
import 'package:applimode_app/src/utils/now_to_int.dart';
import 'package:applimode_app/src/utils/updated_post_ids_list.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_screen_controller.g.dart';

@riverpod
class PostScreenController extends _$PostScreenController {
// ignore: avoid_public_notifier_properties
  Object? key;
  @override
  FutureOr<void> build() {
    key = Object();
    ref.onDispose(() => key = null);
  }

  Future<bool> deletePost({
    required String postId,
    required Post post,
    required bool isAdmin,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null || post.uid != user.uid && isAdmin == false) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }

    state = const AsyncLoading();
    final key = this.key;
    final newState = await AsyncValue.guard(() => PostDeleteService(ref)
        .deletePost(
            uid: post.uid, postId: post.id, isLongContent: post.isLongContent));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('deletePost: ${state.error.toString()}');
      return false;
    }

    ref.read(postsListStateProvider.notifier).set(nowToInt());

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> blockPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.blockPost(postId));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('blockPost: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdsListProvider.notifier).set(postId);

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> unblockPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.unblockPost(postId));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('unblockPost: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdsListProvider.notifier).set(postId);

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> recommendPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.recommendPost(postId));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('recommendPost: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdsListProvider.notifier).set(postId);

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> unrecommendPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.unrecommendPost(postId));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('unrecommendPost: ${state.error.toString()}');
      return false;
    }

    ref.read(updatedPostIdsListProvider.notifier).set(postId);

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> toMainPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.toMainPost(postId));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('toMainPost: ${state.error.toString()}');
      return false;
    }

    ref.read(postsListStateProvider.notifier).set(nowToInt());

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }

  Future<bool> toGeneralPost({
    required String postId,
    required bool isAdmin,
  }) async {
    if (isAdmin == false) {
      state = AsyncError(Exception('permission error'), StackTrace.current);
      return false;
    }
    final postsRepository = ref.read(postsRepositoryProvider);
    state = const AsyncLoading();
    final key = this.key;
    final newState =
        await AsyncValue.guard(() => postsRepository.toGeneralPost(postId));
    if (key == this.key) {
      state = newState;
    }

    if (state.hasError) {
      debugPrint('toGeneralPost: ${state.error.toString()}');
      return false;
    }

    ref.read(postsListStateProvider.notifier).set(nowToInt());

    return true;

    /*
    if (ref.read(goRouterProvider).canPop()) {
      ref.read(goRouterProvider).pop();
    }
    */
  }
}
