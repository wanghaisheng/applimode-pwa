// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_contents_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postContentsRepositoryHash() =>
    r'42daf0d8992ff5542e50d44bd9bd8e71fcc31a08';

/// See also [postContentsRepository].
@ProviderFor(postContentsRepository)
final postContentsRepositoryProvider =
    AutoDisposeProvider<PostContentsRepository>.internal(
  postContentsRepository,
  name: r'postContentsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postContentsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PostContentsRepositoryRef
    = AutoDisposeProviderRef<PostContentsRepository>;
String _$postContentFutureHash() => r'c0e5798969e76d8f0d3bfec9633a1eb5484b26aa';

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

/// See also [postContentFuture].
@ProviderFor(postContentFuture)
const postContentFutureProvider = PostContentFutureFamily();

/// See also [postContentFuture].
class PostContentFutureFamily extends Family<AsyncValue<PostContent?>> {
  /// See also [postContentFuture].
  const PostContentFutureFamily();

  /// See also [postContentFuture].
  PostContentFutureProvider call(
    String id,
  ) {
    return PostContentFutureProvider(
      id,
    );
  }

  @override
  PostContentFutureProvider getProviderOverride(
    covariant PostContentFutureProvider provider,
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
  String? get name => r'postContentFutureProvider';
}

/// See also [postContentFuture].
class PostContentFutureProvider
    extends AutoDisposeFutureProvider<PostContent?> {
  /// See also [postContentFuture].
  PostContentFutureProvider(
    String id,
  ) : this._internal(
          (ref) => postContentFuture(
            ref as PostContentFutureRef,
            id,
          ),
          from: postContentFutureProvider,
          name: r'postContentFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postContentFutureHash,
          dependencies: PostContentFutureFamily._dependencies,
          allTransitiveDependencies:
              PostContentFutureFamily._allTransitiveDependencies,
          id: id,
        );

  PostContentFutureProvider._internal(
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
    FutureOr<PostContent?> Function(PostContentFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostContentFutureProvider._internal(
        (ref) => create(ref as PostContentFutureRef),
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
  AutoDisposeFutureProviderElement<PostContent?> createElement() {
    return _PostContentFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostContentFutureProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PostContentFutureRef on AutoDisposeFutureProviderRef<PostContent?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _PostContentFutureProviderElement
    extends AutoDisposeFutureProviderElement<PostContent?>
    with PostContentFutureRef {
  _PostContentFutureProviderElement(super.provider);

  @override
  String get id => (origin as PostContentFutureProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
