import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:applimode_app/src/features/posts/domain/post_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_contents_repository.g.dart';

class PostContentsRepository {
  const PostContentsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static String postContentsPath() => 'postContents';
  static String postContentPath(String id) => 'postContents/$id';

  Future<void> createPostContent({
    required String id,
    required String uid,
    String content = '',
    int category = 0,
  }) =>
      _firestore.doc(postContentPath(id)).set({
        'id': id,
        'uid': uid,
        'content': content,
        'category': category,
      });

  Future<void> deletePostContent(String id) =>
      _firestore.doc(postContentPath(id)).delete();

  Query<PostContent> postContentsRef() =>
      _firestore.collection(postContentsPath()).withConverter(
            fromFirestore: (snapshot, _) =>
                PostContent.fromMap(snapshot.data() ?? {}),
            toFirestore: (value, _) => value.toMap(),
          );

  DocumentReference<PostContent> postContentRef(String id) =>
      _firestore.doc(postContentPath(id)).withConverter(
            fromFirestore: (snapshot, _) =>
                PostContent.fromMap(snapshot.data() ?? {}),
            toFirestore: (value, _) => value.toMap(),
          );

  Future<PostContent?> fetchPostContent(String id) async {
    final snapshot = await postContentRef(id).get();
    return snapshot.data();
  }

  Future<List<String>> getPostContentIdsForUser(String uid) async {
    final query = await postContentsRef().where('uid', isEqualTo: uid).get();
    return query.docs.map((e) => e.id).toList();
  }
}

@riverpod
PostContentsRepository postContentsRepository(Ref ref) {
  return PostContentsRepository(FirebaseFirestore.instance);
}

@riverpod
FutureOr<PostContent?> postContentFuture(Ref ref, String id) {
  return ref.watch(postContentsRepositoryProvider).fetchPostContent(id);
}
