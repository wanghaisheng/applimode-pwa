import 'package:equatable/equatable.dart';

class PostContent extends Equatable {
  const PostContent({
    this.id = '',
    this.uid = '',
    this.content = '',
    this.category = 0,
  });

  final String id;
  final String uid;
  final String content;
  final int category;

  factory PostContent.fromMap(Map<String, dynamic> map) {
    return PostContent(
      id: map['id'] as String? ?? '',
      uid: map['uid'] as String? ?? '',
      content: map['content'] as String? ?? '',
      category: map['category'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'content': content,
      'category': category,
    };
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        id,
        uid,
        content,
        category,
      ];
}
