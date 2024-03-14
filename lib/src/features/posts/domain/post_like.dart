import 'package:equatable/equatable.dart';

class PostLike extends Equatable {
  const PostLike({
    required this.id,
    required this.uid,
    required this.postId,
    this.isDislike = false,
    required this.createdAt,
  });

  final String id;
  final String uid;
  final String postId;
  final bool isDislike;
  final DateTime createdAt;

  factory PostLike.fromMap(Map<String, dynamic> map) {
    final createdAtInt = map['createdAt'] as int;
    return PostLike(
      id: map['id'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      isDislike: map['isDislike'] as bool? ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtInt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'postId': postId,
      'isDislike': isDislike,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        uid,
        postId,
        isDislike,
        createdAt,
      ];
}
