// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_likes_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postLikesRepositoryHash() =>
    r'd05b70e7b781a31e40b625b1a3508e37c6f312d5';

/// See also [postLikesRepository].
@ProviderFor(postLikesRepository)
final postLikesRepositoryProvider = Provider<PostLikesRepository>.internal(
  postLikesRepository,
  name: r'postLikesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postLikesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PostLikesRepositoryRef = ProviderRef<PostLikesRepository>;
String _$postLikesQueryHash() => r'022f98e20559ce9ac068c832349ee6676aa45123';

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

/// See also [postLikesQuery].
@ProviderFor(postLikesQuery)
const postLikesQueryProvider = PostLikesQueryFamily();

/// See also [postLikesQuery].
class PostLikesQueryFamily extends Family<Query<PostLike>> {
  /// See also [postLikesQuery].
  const PostLikesQueryFamily();

  /// See also [postLikesQuery].
  PostLikesQueryProvider call({
    bool? isDislike,
    String? uid,
    String? postId,
  }) {
    return PostLikesQueryProvider(
      isDislike: isDislike,
      uid: uid,
      postId: postId,
    );
  }

  @override
  PostLikesQueryProvider getProviderOverride(
    covariant PostLikesQueryProvider provider,
  ) {
    return call(
      isDislike: provider.isDislike,
      uid: provider.uid,
      postId: provider.postId,
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
  String? get name => r'postLikesQueryProvider';
}

/// See also [postLikesQuery].
class PostLikesQueryProvider extends AutoDisposeProvider<Query<PostLike>> {
  /// See also [postLikesQuery].
  PostLikesQueryProvider({
    bool? isDislike,
    String? uid,
    String? postId,
  }) : this._internal(
          (ref) => postLikesQuery(
            ref as PostLikesQueryRef,
            isDislike: isDislike,
            uid: uid,
            postId: postId,
          ),
          from: postLikesQueryProvider,
          name: r'postLikesQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postLikesQueryHash,
          dependencies: PostLikesQueryFamily._dependencies,
          allTransitiveDependencies:
              PostLikesQueryFamily._allTransitiveDependencies,
          isDislike: isDislike,
          uid: uid,
          postId: postId,
        );

  PostLikesQueryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isDislike,
    required this.uid,
    required this.postId,
  }) : super.internal();

  final bool? isDislike;
  final String? uid;
  final String? postId;

  @override
  Override overrideWith(
    Query<PostLike> Function(PostLikesQueryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostLikesQueryProvider._internal(
        (ref) => create(ref as PostLikesQueryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isDislike: isDislike,
        uid: uid,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Query<PostLike>> createElement() {
    return _PostLikesQueryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostLikesQueryProvider &&
        other.isDislike == isDislike &&
        other.uid == uid &&
        other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isDislike.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PostLikesQueryRef on AutoDisposeProviderRef<Query<PostLike>> {
  /// The parameter `isDislike` of this provider.
  bool? get isDislike;

  /// The parameter `uid` of this provider.
  String? get uid;

  /// The parameter `postId` of this provider.
  String? get postId;
}

class _PostLikesQueryProviderElement
    extends AutoDisposeProviderElement<Query<PostLike>> with PostLikesQueryRef {
  _PostLikesQueryProviderElement(super.provider);

  @override
  bool? get isDislike => (origin as PostLikesQueryProvider).isDislike;
  @override
  String? get uid => (origin as PostLikesQueryProvider).uid;
  @override
  String? get postId => (origin as PostLikesQueryProvider).postId;
}

String _$postLikesByUserFutureHash() =>
    r'0aa496b85c0594147b8193d2224b73a526712f78';

/// See also [postLikesByUserFuture].
@ProviderFor(postLikesByUserFuture)
const postLikesByUserFutureProvider = PostLikesByUserFutureFamily();

/// See also [postLikesByUserFuture].
class PostLikesByUserFutureFamily extends Family<AsyncValue<List<PostLike>>> {
  /// See also [postLikesByUserFuture].
  const PostLikesByUserFutureFamily();

  /// See also [postLikesByUserFuture].
  PostLikesByUserFutureProvider call({
    required String postId,
    required String uid,
    bool isDislike = false,
  }) {
    return PostLikesByUserFutureProvider(
      postId: postId,
      uid: uid,
      isDislike: isDislike,
    );
  }

  @override
  PostLikesByUserFutureProvider getProviderOverride(
    covariant PostLikesByUserFutureProvider provider,
  ) {
    return call(
      postId: provider.postId,
      uid: provider.uid,
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
  String? get name => r'postLikesByUserFutureProvider';
}

/// See also [postLikesByUserFuture].
class PostLikesByUserFutureProvider
    extends AutoDisposeFutureProvider<List<PostLike>> {
  /// See also [postLikesByUserFuture].
  PostLikesByUserFutureProvider({
    required String postId,
    required String uid,
    bool isDislike = false,
  }) : this._internal(
          (ref) => postLikesByUserFuture(
            ref as PostLikesByUserFutureRef,
            postId: postId,
            uid: uid,
            isDislike: isDislike,
          ),
          from: postLikesByUserFutureProvider,
          name: r'postLikesByUserFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postLikesByUserFutureHash,
          dependencies: PostLikesByUserFutureFamily._dependencies,
          allTransitiveDependencies:
              PostLikesByUserFutureFamily._allTransitiveDependencies,
          postId: postId,
          uid: uid,
          isDislike: isDislike,
        );

  PostLikesByUserFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
    required this.uid,
    required this.isDislike,
  }) : super.internal();

  final String postId;
  final String uid;
  final bool isDislike;

  @override
  Override overrideWith(
    FutureOr<List<PostLike>> Function(PostLikesByUserFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostLikesByUserFutureProvider._internal(
        (ref) => create(ref as PostLikesByUserFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
        uid: uid,
        isDislike: isDislike,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PostLike>> createElement() {
    return _PostLikesByUserFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostLikesByUserFutureProvider &&
        other.postId == postId &&
        other.uid == uid &&
        other.isDislike == isDislike;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, isDislike.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PostLikesByUserFutureRef on AutoDisposeFutureProviderRef<List<PostLike>> {
  /// The parameter `postId` of this provider.
  String get postId;

  /// The parameter `uid` of this provider.
  String get uid;

  /// The parameter `isDislike` of this provider.
  bool get isDislike;
}

class _PostLikesByUserFutureProviderElement
    extends AutoDisposeFutureProviderElement<List<PostLike>>
    with PostLikesByUserFutureRef {
  _PostLikesByUserFutureProviderElement(super.provider);

  @override
  String get postId => (origin as PostLikesByUserFutureProvider).postId;
  @override
  String get uid => (origin as PostLikesByUserFutureProvider).uid;
  @override
  bool get isDislike => (origin as PostLikesByUserFutureProvider).isDislike;
}

String _$postLikesByUserStreamHash() =>
    r'84f30afe39ff38c2f00b1845b75c51a99e647d9a';

/// See also [postLikesByUserStream].
@ProviderFor(postLikesByUserStream)
const postLikesByUserStreamProvider = PostLikesByUserStreamFamily();

/// See also [postLikesByUserStream].
class PostLikesByUserStreamFamily extends Family<AsyncValue<List<PostLike>>> {
  /// See also [postLikesByUserStream].
  const PostLikesByUserStreamFamily();

  /// See also [postLikesByUserStream].
  PostLikesByUserStreamProvider call({
    required String postId,
    required String uid,
  }) {
    return PostLikesByUserStreamProvider(
      postId: postId,
      uid: uid,
    );
  }

  @override
  PostLikesByUserStreamProvider getProviderOverride(
    covariant PostLikesByUserStreamProvider provider,
  ) {
    return call(
      postId: provider.postId,
      uid: provider.uid,
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
  String? get name => r'postLikesByUserStreamProvider';
}

/// See also [postLikesByUserStream].
class PostLikesByUserStreamProvider
    extends AutoDisposeStreamProvider<List<PostLike>> {
  /// See also [postLikesByUserStream].
  PostLikesByUserStreamProvider({
    required String postId,
    required String uid,
  }) : this._internal(
          (ref) => postLikesByUserStream(
            ref as PostLikesByUserStreamRef,
            postId: postId,
            uid: uid,
          ),
          from: postLikesByUserStreamProvider,
          name: r'postLikesByUserStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postLikesByUserStreamHash,
          dependencies: PostLikesByUserStreamFamily._dependencies,
          allTransitiveDependencies:
              PostLikesByUserStreamFamily._allTransitiveDependencies,
          postId: postId,
          uid: uid,
        );

  PostLikesByUserStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
    required this.uid,
  }) : super.internal();

  final String postId;
  final String uid;

  @override
  Override overrideWith(
    Stream<List<PostLike>> Function(PostLikesByUserStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostLikesByUserStreamProvider._internal(
        (ref) => create(ref as PostLikesByUserStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PostLike>> createElement() {
    return _PostLikesByUserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostLikesByUserStreamProvider &&
        other.postId == postId &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PostLikesByUserStreamRef on AutoDisposeStreamProviderRef<List<PostLike>> {
  /// The parameter `postId` of this provider.
  String get postId;

  /// The parameter `uid` of this provider.
  String get uid;
}

class _PostLikesByUserStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<PostLike>>
    with PostLikesByUserStreamRef {
  _PostLikesByUserStreamProviderElement(super.provider);

  @override
  String get postId => (origin as PostLikesByUserStreamProvider).postId;
  @override
  String get uid => (origin as PostLikesByUserStreamProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
