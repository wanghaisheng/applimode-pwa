// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comments_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postCommentsRepositoryHash() =>
    r'aca9b137f292cd12b64f83e4041068bb92201254';

/// See also [postCommentsRepository].
@ProviderFor(postCommentsRepository)
final postCommentsRepositoryProvider =
    Provider<PostCommentsRepository>.internal(
  postCommentsRepository,
  name: r'postCommentsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postCommentsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PostCommentsRepositoryRef = ProviderRef<PostCommentsRepository>;
String _$postCommentsQueryHash() => r'c7510a1d9c4f3baffb556eb709cb5a7abaa5083a';

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

/// See also [postCommentsQuery].
@ProviderFor(postCommentsQuery)
const postCommentsQueryProvider = PostCommentsQueryFamily();

/// See also [postCommentsQuery].
class PostCommentsQueryFamily extends Family<Query<PostComment>> {
  /// See also [postCommentsQuery].
  const PostCommentsQueryFamily();

  /// See also [postCommentsQuery].
  PostCommentsQueryProvider call({
    String? postId,
    String? uid,
    bool byCreatedAt = true,
    bool byCommentCount = false,
    bool byLikeCount = false,
    bool byDislikeCount = false,
    bool bySumCount = false,
    int? day,
    int? month,
    int? year,
  }) {
    return PostCommentsQueryProvider(
      postId: postId,
      uid: uid,
      byCreatedAt: byCreatedAt,
      byCommentCount: byCommentCount,
      byLikeCount: byLikeCount,
      byDislikeCount: byDislikeCount,
      bySumCount: bySumCount,
      day: day,
      month: month,
      year: year,
    );
  }

  @override
  PostCommentsQueryProvider getProviderOverride(
    covariant PostCommentsQueryProvider provider,
  ) {
    return call(
      postId: provider.postId,
      uid: provider.uid,
      byCreatedAt: provider.byCreatedAt,
      byCommentCount: provider.byCommentCount,
      byLikeCount: provider.byLikeCount,
      byDislikeCount: provider.byDislikeCount,
      bySumCount: provider.bySumCount,
      day: provider.day,
      month: provider.month,
      year: provider.year,
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
  String? get name => r'postCommentsQueryProvider';
}

/// See also [postCommentsQuery].
class PostCommentsQueryProvider
    extends AutoDisposeProvider<Query<PostComment>> {
  /// See also [postCommentsQuery].
  PostCommentsQueryProvider({
    String? postId,
    String? uid,
    bool byCreatedAt = true,
    bool byCommentCount = false,
    bool byLikeCount = false,
    bool byDislikeCount = false,
    bool bySumCount = false,
    int? day,
    int? month,
    int? year,
  }) : this._internal(
          (ref) => postCommentsQuery(
            ref as PostCommentsQueryRef,
            postId: postId,
            uid: uid,
            byCreatedAt: byCreatedAt,
            byCommentCount: byCommentCount,
            byLikeCount: byLikeCount,
            byDislikeCount: byDislikeCount,
            bySumCount: bySumCount,
            day: day,
            month: month,
            year: year,
          ),
          from: postCommentsQueryProvider,
          name: r'postCommentsQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postCommentsQueryHash,
          dependencies: PostCommentsQueryFamily._dependencies,
          allTransitiveDependencies:
              PostCommentsQueryFamily._allTransitiveDependencies,
          postId: postId,
          uid: uid,
          byCreatedAt: byCreatedAt,
          byCommentCount: byCommentCount,
          byLikeCount: byLikeCount,
          byDislikeCount: byDislikeCount,
          bySumCount: bySumCount,
          day: day,
          month: month,
          year: year,
        );

  PostCommentsQueryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
    required this.uid,
    required this.byCreatedAt,
    required this.byCommentCount,
    required this.byLikeCount,
    required this.byDislikeCount,
    required this.bySumCount,
    required this.day,
    required this.month,
    required this.year,
  }) : super.internal();

  final String? postId;
  final String? uid;
  final bool byCreatedAt;
  final bool byCommentCount;
  final bool byLikeCount;
  final bool byDislikeCount;
  final bool bySumCount;
  final int? day;
  final int? month;
  final int? year;

  @override
  Override overrideWith(
    Query<PostComment> Function(PostCommentsQueryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostCommentsQueryProvider._internal(
        (ref) => create(ref as PostCommentsQueryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
        uid: uid,
        byCreatedAt: byCreatedAt,
        byCommentCount: byCommentCount,
        byLikeCount: byLikeCount,
        byDislikeCount: byDislikeCount,
        bySumCount: bySumCount,
        day: day,
        month: month,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Query<PostComment>> createElement() {
    return _PostCommentsQueryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentsQueryProvider &&
        other.postId == postId &&
        other.uid == uid &&
        other.byCreatedAt == byCreatedAt &&
        other.byCommentCount == byCommentCount &&
        other.byLikeCount == byLikeCount &&
        other.byDislikeCount == byDislikeCount &&
        other.bySumCount == bySumCount &&
        other.day == day &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);
    hash = _SystemHash.combine(hash, byCreatedAt.hashCode);
    hash = _SystemHash.combine(hash, byCommentCount.hashCode);
    hash = _SystemHash.combine(hash, byLikeCount.hashCode);
    hash = _SystemHash.combine(hash, byDislikeCount.hashCode);
    hash = _SystemHash.combine(hash, bySumCount.hashCode);
    hash = _SystemHash.combine(hash, day.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostCommentsQueryRef on AutoDisposeProviderRef<Query<PostComment>> {
  /// The parameter `postId` of this provider.
  String? get postId;

  /// The parameter `uid` of this provider.
  String? get uid;

  /// The parameter `byCreatedAt` of this provider.
  bool get byCreatedAt;

  /// The parameter `byCommentCount` of this provider.
  bool get byCommentCount;

  /// The parameter `byLikeCount` of this provider.
  bool get byLikeCount;

  /// The parameter `byDislikeCount` of this provider.
  bool get byDislikeCount;

  /// The parameter `bySumCount` of this provider.
  bool get bySumCount;

  /// The parameter `day` of this provider.
  int? get day;

  /// The parameter `month` of this provider.
  int? get month;

  /// The parameter `year` of this provider.
  int? get year;
}

class _PostCommentsQueryProviderElement
    extends AutoDisposeProviderElement<Query<PostComment>>
    with PostCommentsQueryRef {
  _PostCommentsQueryProviderElement(super.provider);

  @override
  String? get postId => (origin as PostCommentsQueryProvider).postId;
  @override
  String? get uid => (origin as PostCommentsQueryProvider).uid;
  @override
  bool get byCreatedAt => (origin as PostCommentsQueryProvider).byCreatedAt;
  @override
  bool get byCommentCount =>
      (origin as PostCommentsQueryProvider).byCommentCount;
  @override
  bool get byLikeCount => (origin as PostCommentsQueryProvider).byLikeCount;
  @override
  bool get byDislikeCount =>
      (origin as PostCommentsQueryProvider).byDislikeCount;
  @override
  bool get bySumCount => (origin as PostCommentsQueryProvider).bySumCount;
  @override
  int? get day => (origin as PostCommentsQueryProvider).day;
  @override
  int? get month => (origin as PostCommentsQueryProvider).month;
  @override
  int? get year => (origin as PostCommentsQueryProvider).year;
}

String _$postCommentRepliesQueryHash() =>
    r'91d5e9bf958e8a9c1e10f0851545e2f82eefac42';

/// See also [postCommentRepliesQuery].
@ProviderFor(postCommentRepliesQuery)
const postCommentRepliesQueryProvider = PostCommentRepliesQueryFamily();

/// See also [postCommentRepliesQuery].
class PostCommentRepliesQueryFamily extends Family<Query<PostComment>> {
  /// See also [postCommentRepliesQuery].
  const PostCommentRepliesQueryFamily();

  /// See also [postCommentRepliesQuery].
  PostCommentRepliesQueryProvider call(
    String parentCommentId,
  ) {
    return PostCommentRepliesQueryProvider(
      parentCommentId,
    );
  }

  @override
  PostCommentRepliesQueryProvider getProviderOverride(
    covariant PostCommentRepliesQueryProvider provider,
  ) {
    return call(
      provider.parentCommentId,
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
  String? get name => r'postCommentRepliesQueryProvider';
}

/// See also [postCommentRepliesQuery].
class PostCommentRepliesQueryProvider
    extends AutoDisposeProvider<Query<PostComment>> {
  /// See also [postCommentRepliesQuery].
  PostCommentRepliesQueryProvider(
    String parentCommentId,
  ) : this._internal(
          (ref) => postCommentRepliesQuery(
            ref as PostCommentRepliesQueryRef,
            parentCommentId,
          ),
          from: postCommentRepliesQueryProvider,
          name: r'postCommentRepliesQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postCommentRepliesQueryHash,
          dependencies: PostCommentRepliesQueryFamily._dependencies,
          allTransitiveDependencies:
              PostCommentRepliesQueryFamily._allTransitiveDependencies,
          parentCommentId: parentCommentId,
        );

  PostCommentRepliesQueryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parentCommentId,
  }) : super.internal();

  final String parentCommentId;

  @override
  Override overrideWith(
    Query<PostComment> Function(PostCommentRepliesQueryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostCommentRepliesQueryProvider._internal(
        (ref) => create(ref as PostCommentRepliesQueryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parentCommentId: parentCommentId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Query<PostComment>> createElement() {
    return _PostCommentRepliesQueryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentRepliesQueryProvider &&
        other.parentCommentId == parentCommentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parentCommentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostCommentRepliesQueryRef on AutoDisposeProviderRef<Query<PostComment>> {
  /// The parameter `parentCommentId` of this provider.
  String get parentCommentId;
}

class _PostCommentRepliesQueryProviderElement
    extends AutoDisposeProviderElement<Query<PostComment>>
    with PostCommentRepliesQueryRef {
  _PostCommentRepliesQueryProviderElement(super.provider);

  @override
  String get parentCommentId =>
      (origin as PostCommentRepliesQueryProvider).parentCommentId;
}

String _$postCommentFutureHash() => r'70a5cb82ced9192471f2dff7b0a2030c205d8bba';

/// See also [postCommentFuture].
@ProviderFor(postCommentFuture)
const postCommentFutureProvider = PostCommentFutureFamily();

/// See also [postCommentFuture].
class PostCommentFutureFamily extends Family<AsyncValue<PostComment?>> {
  /// See also [postCommentFuture].
  const PostCommentFutureFamily();

  /// See also [postCommentFuture].
  PostCommentFutureProvider call(
    String id,
  ) {
    return PostCommentFutureProvider(
      id,
    );
  }

  @override
  PostCommentFutureProvider getProviderOverride(
    covariant PostCommentFutureProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'postCommentFutureProvider';
}

/// See also [postCommentFuture].
class PostCommentFutureProvider
    extends AutoDisposeFutureProvider<PostComment?> {
  /// See also [postCommentFuture].
  PostCommentFutureProvider(
    String id,
  ) : this._internal(
          (ref) => postCommentFuture(
            ref as PostCommentFutureRef,
            id,
          ),
          from: postCommentFutureProvider,
          name: r'postCommentFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postCommentFutureHash,
          dependencies: PostCommentFutureFamily._dependencies,
          allTransitiveDependencies:
              PostCommentFutureFamily._allTransitiveDependencies,
          id: id,
        );

  PostCommentFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<PostComment?> Function(PostCommentFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostCommentFutureProvider._internal(
        (ref) => create(ref as PostCommentFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PostComment?> createElement() {
    return _PostCommentFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostCommentFutureProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostCommentFutureRef on AutoDisposeFutureProviderRef<PostComment?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PostCommentFutureProviderElement
    extends AutoDisposeFutureProviderElement<PostComment?>
    with PostCommentFutureRef {
  _PostCommentFutureProviderElement(super.provider);

  @override
  String get id => (origin as PostCommentFutureProvider).id;
}

String _$bestPostCommentsFutureHash() =>
    r'09648ad4e9ed49e42dd9da0c23dc913e83d4f3b1';

/// See also [bestPostCommentsFuture].
@ProviderFor(bestPostCommentsFuture)
const bestPostCommentsFutureProvider = BestPostCommentsFutureFamily();

/// See also [bestPostCommentsFuture].
class BestPostCommentsFutureFamily
    extends Family<AsyncValue<List<PostComment>>> {
  /// See also [bestPostCommentsFuture].
  const BestPostCommentsFutureFamily();

  /// See also [bestPostCommentsFuture].
  BestPostCommentsFutureProvider call(
    String postId,
  ) {
    return BestPostCommentsFutureProvider(
      postId,
    );
  }

  @override
  BestPostCommentsFutureProvider getProviderOverride(
    covariant BestPostCommentsFutureProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'bestPostCommentsFutureProvider';
}

/// See also [bestPostCommentsFuture].
class BestPostCommentsFutureProvider
    extends AutoDisposeFutureProvider<List<PostComment>> {
  /// See also [bestPostCommentsFuture].
  BestPostCommentsFutureProvider(
    String postId,
  ) : this._internal(
          (ref) => bestPostCommentsFuture(
            ref as BestPostCommentsFutureRef,
            postId,
          ),
          from: bestPostCommentsFutureProvider,
          name: r'bestPostCommentsFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bestPostCommentsFutureHash,
          dependencies: BestPostCommentsFutureFamily._dependencies,
          allTransitiveDependencies:
              BestPostCommentsFutureFamily._allTransitiveDependencies,
          postId: postId,
        );

  BestPostCommentsFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<List<PostComment>> Function(BestPostCommentsFutureRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BestPostCommentsFutureProvider._internal(
        (ref) => create(ref as BestPostCommentsFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PostComment>> createElement() {
    return _BestPostCommentsFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BestPostCommentsFutureProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BestPostCommentsFutureRef
    on AutoDisposeFutureProviderRef<List<PostComment>> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _BestPostCommentsFutureProviderElement
    extends AutoDisposeFutureProviderElement<List<PostComment>>
    with BestPostCommentsFutureRef {
  _BestPostCommentsFutureProviderElement(super.provider);

  @override
  String get postId => (origin as BestPostCommentsFutureProvider).postId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
