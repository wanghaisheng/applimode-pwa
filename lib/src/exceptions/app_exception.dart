sealed class AppException implements Exception {
  AppException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => message;
}

class ImageReadFailedException implements Exception {
  ImageReadFailedException();

  static const code = 'image-read-failed';
  static const title = 'Image Upload Error';
  static const message =
      'Something is wrong with your images. Please correct and try again.';

  @override
  String toString() => message;
}

class ImagesLengthException implements Exception {
  ImagesLengthException();

  static const code = 'images-length-failed';
  static const title = 'Image Length Error';
  static const message = 'Please check your the number of your images.';

  @override
  String toString() => message;
}

class PostDeleteException implements Exception {
  PostDeleteException();

  static const code = 'post-delete-failed';
  static const title = 'Post Delete Error';
  static const message = 'You can not delete this post.';

  @override
  String toString() => message;
}

class FileSizeException implements Exception {
  FileSizeException();
}
