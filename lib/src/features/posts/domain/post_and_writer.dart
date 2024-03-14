import 'package:applimode_app/src/features/authentication/domain/app_user.dart';
import 'package:applimode_app/src/features/posts/domain/post.dart';

class PostAndWriter {
  const PostAndWriter({
    required this.post,
    required this.writer,
  });

  final Post post;
  final AppUser writer;
}
