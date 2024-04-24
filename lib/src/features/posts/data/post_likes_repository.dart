import 'package:applimode_app/src/features/posts/domain/post_like.dart';
import 'package:applimode_app/custom_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_likes_repository.g.dart';

class PostLikesRepository {
  const PostLikesRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const limit = listFetchLimit;

  static String postLikesPath() => 'postLikes';
  static String postLikePath(String id) => 'postLikes/$id';

  Future<void> createPostLike({
    required String id,
    required String uid,
    required String postId,
    required String postWriterId,
    bool isDislike = false,
    required DateTime createdAt,
  }) =>
      _firestore.doc(postLikePath(id)).set({
        'id': id,
        'uid': uid,
        'postId': postId,
        'postWriterId': postWriterId,
        'isDislike': isDislike,
        'createdAt': createdAt.millisecondsSinceEpoch,
      });

  Future<void> deletePostLike(String id) =>
      _firestore.doc(postLikePath(id)).delete();

  Query<PostLike> postLikesRef({
    bool? isDislike,
    String? uid,
    String? postId,
  }) {
    Query<PostLike> query = _firestore
        .collection(postLikesPath())
        .withConverter(
          fromFirestore: (snapshot, _) => PostLike.fromMap(snapshot.data()!),
          toFirestore: (value, _) => value.toMap(),
        );

    // User likes, dislikes query
    // 사용자 좋아요, 싫어요 쿼리
    if (uid != null && isDislike == null) {
      return query.where('uid', isEqualTo: uid);
    }

    // User likes query
    // 사용자 좋아요 쿼리
    if (uid != null && isDislike == false) {
      return query
          .where('uid', isEqualTo: uid)
          .where('isDislike', isEqualTo: false);
    }

    // user dislike query
    // 사용자 싫어요 쿼리
    if (uid != null && isDislike == true) {
      return query
          .where('uid', isEqualTo: uid)
          .where('isDislike', isEqualTo: true);
    }

    // Post like/dislike query
    // 포스트 좋아요 싫어요 쿼리
    if (postId != null && isDislike == null) {
      return query.where('postId', isEqualTo: postId);
    }

    // Post like query
    // 포스트 좋아요 쿼리
    if (postId != null && isDislike == false) {
      return query
          .where('postId', isEqualTo: postId)
          .where('isDislike', isEqualTo: false);
    }

    // post dislike query
    // 포스트 싫어요 쿼리
    if (postId != null && isDislike == true) {
      return query
          .where('postId', isEqualTo: postId)
          .where('isDislike', isEqualTo: true);
    }

    return query;
  }

  // Get all likes and dislikes IDs when deleting a post
  // 포스트 삭제시 모든 좋아요 싫어요 아이디 가져오기
  Future<List<String>> getPostLikeIdsForPost(String postId) async {
    final query = await postLikesRef(postId: postId).get();
    return query.docs.map((e) => e.id).toList();
  }

  // Check the user's likes/dislikes status for each post
  // 각 포스트에 대한 사용자의 좋아요 싫어요 상태 확인
  Future<List<PostLike>> fetchPostLikesByUser({
    required String postId,
    required String uid,
    bool isDislike = false,
  }) async {
    final postLikesSnapshot = await postLikesRef()
        .where('postId', isEqualTo: postId)
        .where('uid', isEqualTo: uid)
        .where('isDislike', isEqualTo: isDislike)
        .get();
    return postLikesSnapshot.docs.map((e) => e.data()).toList();
  }

  // the user's likes and dislikes status stream for each post
  // 각 포스트에 대한 사용자의 좋아요 싫어요 상태 스트림
  Stream<List<PostLike>> watchPostLikesByUser({
    required String postId,
    required String uid,
  }) =>
      postLikesRef()
          .where('postId', isEqualTo: postId)
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  // Get all likes and dislikes IDs when remove account
  // 회원 탈퇴시 모든 좋아요 싫어요 아이디 가져오기
  Future<List<String>> getPostLikeIdsForUser(String uid) async {
    final query = await postLikesRef(uid: uid).get();
    return query.docs.map((e) => e.id).toList();
  }

  // Get all likes and dislikes IDs of deleted posts when remove account
  // 회원 탈퇴시 삭제될 포스트의 모든 좋아요 싫어요 아이디 가져오기
  Future<List<String>> getPostLikeIdsForPostWriter(String uid) async {
    final query =
        await postLikesRef().where('postWriterId', isEqualTo: uid).get();
    return query.docs.map((e) => e.id).toList();
  }
}

@Riverpod(keepAlive: true)
PostLikesRepository postLikesRepository(PostLikesRepositoryRef ref) {
  return PostLikesRepository(FirebaseFirestore.instance);
}

@riverpod
Query<PostLike> postLikesQuery(
  PostLikesQueryRef ref, {
  bool? isDislike,
  String? uid,
  String? postId,
}) {
  final postLikesRepository = ref.watch(postLikesRepositoryProvider);
  return postLikesRepository.postLikesRef(
    isDislike: isDislike,
    uid: uid,
    postId: postId,
  );
}

@riverpod
FutureOr<List<PostLike>> postLikesByUserFuture(
  PostLikesByUserFutureRef ref, {
  required String postId,
  required String uid,
  bool isDislike = false,
}) {
  return ref.watch(postLikesRepositoryProvider).fetchPostLikesByUser(
        postId: postId,
        uid: uid,
        isDislike: isDislike,
      );
}

@riverpod
Stream<List<PostLike>> postLikesByUserStream(
  PostLikesByUserStreamRef ref, {
  required String postId,
  required String uid,
}) {
  return ref
      .watch(postLikesRepositoryProvider)
      .watchPostLikesByUser(postId: postId, uid: uid);
}
