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
    await postLikesRepository.createPostLike(
      id: id,
      uid: uid,
      postId: postId,
      createdAt: DateTime.now(),
    );
    await postsRepository.increaseLikeCount(postId);
    await appUserRepository.increaseLikeCount(writerId);
  }

  Future<void> decreasePostLikeCount({
    required String id,
    required String postId,
    required String writerId,
  }) async {
    await postLikesRepository.deletePostLike(id);
    await postsRepository.decreaseLikeCount(postId);
    await appUserRepository.decreaseLikeCount(writerId);
  }

  Future<void> increasePostDislikeCount({
    required String id,
    required String uid,
    required String postId,
    required String writerId,
  }) async {
    await postLikesRepository.createPostLike(
      id: id,
      uid: uid,
      postId: postId,
      isDislike: true,
      createdAt: DateTime.now(),
    );
    await postsRepository.increaseDislikeCount(postId);
    await appUserRepository.increaseDislikeCount(writerId);
  }

  Future<void> decreasePostDislikeCount({
    required String id,
    required String postId,
    required String writerId,
  }) async {
    await postLikesRepository.deletePostLike(id);
    await postsRepository.decreaseDislikeCount(postId);
    await appUserRepository.decreaseDislikeCount(writerId);
  }
}

@riverpod
PostLikesService postLikesService(PostLikesServiceRef ref) {
  return PostLikesService(ref);
}
