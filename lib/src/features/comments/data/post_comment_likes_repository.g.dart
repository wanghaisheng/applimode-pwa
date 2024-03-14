// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_likes_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postCommentLikesRepositoryHash() =>
    r'64e743f1ca3de315b959fe853727110bdf3ac436';

/// See also [postCommentLikesRepository].
@ProviderFor(postCommentLikesRepository)
final postCommentLikesRepositoryProvider =
    Provider<PostCommentLikesRepository>.internal(
  postCommentLikesRepository,
  name: r'postCommentLikesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postCommentLikesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PostCommentLikesRepositoryRef = ProviderRef<PostCommentLikesRepository>;
String _$postCommentLikesQueryHash() =>
    r'd0a21b6b86ddc785ff7e357239151ba1f4de1473';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [postCommentLikesQuery].
@ProviderFor(postCommentLikesQuery)
const postCommentLikesQueryProvider = PostCommentLikesQueryFamily();

/// See also [postCommentLikesQuery].
class PostCommentLikesQueryFamily extends Family<Query<PostCommentLike>> {
  /// See also [postCommentLikesQuery].
  const PostCommentLikesQueryFamily();

  /// See also [postCommentLikesQuery].
  PostCommentLikesQueryProvider call({
    bool? isDislike,
    String? uid,
    String? commentId,
  }) {
    return PostCommentLikesQueryProvider(
      isDislike: isDislike,
      uid: uid,
      commentId: commentId,
    );
  }

  @override
  PostCommentLikesQueryProvider getProviderOverride(
    covariant PostCommentLikesQueryProvider provider,
  ) {
    return call(
      isDislike: provider.isDislike,
      uid: provider.uid,
      commentId: provider.commentId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postCommentLikesQueryProvider';
}

/// See also [postCommentLikesQuery].
class PostCommentLikesQueryProvider
    extends AutoDisposeProvider<Query<PostCommentLike>> {
  /// See also [postCommentLikesQuery].
  PostCommentLikesQueryProvider({
    bool? isDislike,
    String? uid,
    String? commentId,
  }) : this._internal(
          (ref) => postCommentLikesQuery(
            ref as PostCommentLikesQueryRef,
            isDislike: isDislike,
            uid: uid,
            commentId: commentId,
          ),
          from: postCommentLikesQueryProvider,
          name: r'postCommentLikesQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postCommentLikesQueryHash,
          dependencies: PostCommentLikesQueryFamily._dependencies,
          allTransitiveDependencies:
              PostCommentLikesQueryFamily._allTransitiveDependencies,
          isDislike: isDislike,
          uid: uid,
          commentId: commentId,
        );

  PostCommentLikesQueryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isDislike,
    required this.uid,
    required this.commentId,
  }) : super.internal();

  final bool? isDislike;
  final String? uid;
  final String? commentId;

  @override
  Override overrideWith(
    Query<PostCommentLike> Function(PostCommentLikesQueryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostCommentLikesQueryProvider._internal(
        (ref) => create(ref as PostCommentLikesQueryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isDislike: isDislike,
        uid: uid,
        commentId: commentId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Query<PostCommentLike>> createElement() {
    return _PostCommentLikesQueryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentLikesQueryProvider &&
        other.isDislike == isDislike &&
        other.uid == uid &&
        other.commentId == commentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isDislike.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, commentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PostCommentLikesQueryRef
    on AutoDisposeProviderRef<Query<PostCommentLike>> {
  /// The parameter `isDislike` of this provider.
  bool? get isDislike;

  /// The parameter `uid` of this provider.
  String? get uid;

  /// The parameter `commentId` of this provider.
  String? get commentId;
}

class _PostCommentLikesQueryProviderElement
    extends AutoDisposeProviderElement<Query<PostCommentLike>>
    with PostCommentLikesQueryRef {
  _PostCommentLikesQueryProviderElement(super.provider);

  @override
  bool? get isDislike => (origin as PostCommentLikesQueryProvider).isDislike;
  @override
  String? get uid => (origin as PostCommentLikesQueryProvider).uid;
  @override
  String? get commentId => (origin as PostCommentLikesQueryProvider).commentId;
}

String _$postCommentLikesByUserFutureHash() =>
    r'7529422c03b2b28158bfca930dd8fe3d84336fca';

/// See also [postCommentLikesByUserFuture].
@ProviderFor(postCommentLikesByUserFuture)
const postCommentLikesByUserFutureProvider =
    PostCommentLikesByUserFutureFamily();

/// See also [postCommentLikesByUserFuture].
class PostCommentLikesByUserFutureFamily
    extends Family<AsyncValue<List<PostCommentLike>>> {
  /// See also [postCommentLikesByUserFuture].
  const PostCommentLikesByUserFutureFamily();

  /// See also [postCommentLikesByUserFuture].
  PostCommentLikesByUserFutureProvider call({
    required String uid,
    required String commentId,
    bool isDislike = false,
  }) {
    return PostCommentLikesByUserFutureProvider(
      uid: uid,
      commentId: commentId,
      isDislike: isDislike,
    );
  }

  @override
  PostCommentLikesByUserFutureProvider getProviderOverride(
    covariant PostCommentLikesByUserFutureProvider provider,
  ) {
    return call(
      uid: provider.uid,
      commentId: provider.commentId,
      isDislike: provider.isDislike,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postCommentLikesByUserFutureProvider';
}

/// See also [postCommentLikesByUserFuture].
class PostCommentLikesByUserFutureProvider
    extends AutoDisposeFutureProvider<List<PostCommentLike>> {
  /// See also [postCommentLikesByUserFuture].
  PostCommentLikesByUserFutureProvider({
    required String uid,
    required String commentId,
    bool isDislike = false,
  }) : this._internal(
          (ref) => postCommentLikesByUserFuture(
            ref as PostCommentLikesByUserFutureRef,
            uid: uid,
            commentId: commentId,
            isDislike: isDislike,
          ),
          from: postCommentLikesByUserFutureProvider,
          name: r'postCommentLikesByUserFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postCommentLikesByUserFutureHash,
          dependencies: PostCommentLikesByUserFutureFamily._dependencies,
          allTransitiveDependencies:
              PostCommentLikesByUserFutureFamily._allTransitiveDependencies,
          uid: uid,
          commentId: commentId,
          isDislike: isDislike,
        );

  PostCommentLikesByUserFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
    required this.commentId,
    required this.isDislike,
  }) : super.internal();

  final String uid;
  final String commentId;
  final bool isDislike;

  @override
  Override overrideWith(
    FutureOr<List<PostCommentLike>> Function(
            PostCommentLikesByUserFutureRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostCommentLikesByUserFutureProvider._internal(
        (ref) => create(ref as PostCommentLikesByUserFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
        commentId: commentId,
        isDislike: isDislike,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PostCommentLike>> createElement() {
    return _PostCommentLikesByUserFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentLikesByUserFutureProvider &&
        other.uid == uid &&
        other.commentId == commentId &&
        other.isDislike == isDislike;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, commentId.hashCode);
    hash = _SystemHash.combine(hash, isDislike.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PostCommentLikesByUserFutureRef
    on AutoDisposeFutureProviderRef<List<PostCommentLike>> {
  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `commentId` of this provider.
  String get commentId;

  /// The parameter `isDislike` of this provider.
  bool get isDislike;
}

class _PostCommentLikesByUserFutureProviderElement
    extends AutoDisposeFutureProviderElement<List<PostCommentLike>>
    with PostCommentLikesByUserFutureRef {
  _PostCommentLikesByUserFutureProviderElement(super.provider);

  @override
  String get uid => (origin as PostCommentLikesByUserFutureProvider).uid;
  @override
  String get commentId =>
      (origin as PostCommentLikesByUserFutureProvider).commentId;
  @override
  bool get isDislike =>
      (origin as PostCommentLikesByUserFutureProvider).isDislike;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
