import 'package:applimode_app/src/features/authentication/data/app_user_repository.dart';
import 'package:applimode_app/src/features/posts/data/post_likes_repository.dart';
import 'package:applimode_app/src/features/posts/data/posts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_likes_service.g.dart';

class PostLikesService {
  const PostLikesService(this.ref);

  final Ref ref;

  PostLikesRepository get postLikesRepository =>
      ref.read(postLikesRepositoryProvider);
  PostsRepository get postsRepository => ref.read(postsRepositoryProvider);
  AppUserRepository get appUserRepository =>
      ref.read(appUserRepositoryProvider);

  Future<void> increasePostLikeCount({
    required String id,
    required String uid,
    required String postId,
    required String writerId,
  }) async {
    await postsRepository.increaseLikeCount(postId);
    await appUserRepository.increaseLikeCount(writerId);
    await postLikesRepository.createPostLike(
      id: id,
      uid: uid,
      postId: postId,
      createdAt: DateTime.now(),
    );
  }

  Future<void> decreasePostLikeCount({
    required String id,
    required String postId,
    required String writerId,
  }) async {
    await postsRepository.decreaseLikeCount(postId);
    await appUserRepository.decreaseLikeCount(writerId);
    await postLikesRepository.deletePostLike(id);
  }

  Future<void> increasePostDislikeCount({
    required String id,
    required String uid,
    required String postId,
    required String writerId,
  }) async {
    await postsRepository.increaseDislikeCount(postId);
    await appUserRepository.increaseDislikeCount(writerId);
    await postLikesRepository.createPostLike(
      id: id,
      uid: uid,
      postId: postId,
      isDislike: true,
      createdAt: DateTime.now(),
    );
  }

  Future<void> decreasePostDislikeCount({
    required String id,
    required String postId,
    required String writerId,
  }) async {
    await postsRepository.decreaseDislikeCount(postId);
    await appUserRepository.decreaseDislikeCount(writerId);
    await postLikesRepository.deletePostLike(id);
  }
}

@riverpod
PostLikesService postLikesService(PostLikesServiceRef ref) {
  return PostLikesService(ref);
}
