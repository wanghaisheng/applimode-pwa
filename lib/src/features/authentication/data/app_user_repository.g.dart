// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appUserRepositoryHash() => r'16481fa140efbaf7c95cf86f6d80dd63c26ac4f1';

/// See also [appUserRepository].
@ProviderFor(appUserRepository)
final appUserRepositoryProvider = Provider<AppUserRepository>.internal(
  appUserRepository,
  name: r'appUserRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUserRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppUserRepositoryRef = ProviderRef<AppUserRepository>;
String _$appUserFutureHash() => r'ee9828a0ad470fe0c82d586feeed25cc63118bef';

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

/// See also [appUserFuture].
@ProviderFor(appUserFuture)
const appUserFutureProvider = AppUserFutureFamily();

/// See also [appUserFuture].
class AppUserFutureFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [appUserFuture].
  const AppUserFutureFamily();

  /// See also [appUserFuture].
  AppUserFutureProvider call(
    String uid,
  ) {
    return AppUserFutureProvider(
      uid,
    );
  }

  @override
  AppUserFutureProvider getProviderOverride(
    covariant AppUserFutureProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'appUserFutureProvider';
}

/// See also [appUserFuture].
class AppUserFutureProvider extends FutureProvider<AppUser?> {
  /// See also [appUserFuture].
  AppUserFutureProvider(
    String uid,
  ) : this._internal(
          (ref) => appUserFuture(
            ref as AppUserFutureRef,
            uid,
          ),
          from: appUserFutureProvider,
          name: r'appUserFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appUserFutureHash,
          dependencies: AppUserFutureFamily._dependencies,
          allTransitiveDependencies:
              AppUserFutureFamily._allTransitiveDependencies,
          uid: uid,
        );

  AppUserFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(AppUserFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppUserFutureProvider._internal(
        (ref) => create(ref as AppUserFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  FutureProviderElement<AppUser?> createElement() {
    return _AppUserFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppUserFutureProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AppUserFutureRef on FutureProviderRef<AppUser?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _AppUserFutureProviderElement extends FutureProviderElement<AppUser?>
    with AppUserFutureRef {
  _AppUserFutureProviderElement(super.provider);

  @override
  String get uid => (origin as AppUserFutureProvider).uid;
}

String _$writerFutureHash() => r'64dad68db5a51fbf684a6af5354e3ea2893ee36f';

/// See also [writerFuture].
@ProviderFor(writerFuture)
const writerFutureProvider = WriterFutureFamily();

/// See also [writerFuture].
class WriterFutureFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [writerFuture].
  const WriterFutureFamily();

  /// See also [writerFuture].
  WriterFutureProvider call(
    String uid,
  ) {
    return WriterFutureProvider(
      uid,
    );
  }

  @override
  WriterFutureProvider getProviderOverride(
    covariant WriterFutureProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'writerFutureProvider';
}

/// See also [writerFuture].
class WriterFutureProvider extends AutoDisposeFutureProvider<AppUser?> {
  /// See also [writerFuture].
  WriterFutureProvider(
    String uid,
  ) : this._internal(
          (ref) => writerFuture(
            ref as WriterFutureRef,
            uid,
          ),
          from: writerFutureProvider,
          name: r'writerFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$writerFutureHash,
          dependencies: WriterFutureFamily._dependencies,
          allTransitiveDependencies:
              WriterFutureFamily._allTransitiveDependencies,
          uid: uid,
        );

  WriterFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(WriterFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WriterFutureProvider._internal(
        (ref) => create(ref as WriterFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser?> createElement() {
    return _WriterFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WriterFutureProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WriterFutureRef on AutoDisposeFutureProviderRef<AppUser?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _WriterFutureProviderElement
    extends AutoDisposeFutureProviderElement<AppUser?> with WriterFutureRef {
  _WriterFutureProviderElement(super.provider);

  @override
  String get uid => (origin as WriterFutureProvider).uid;
}

String _$appUserStreamHash() => r'eff042bbd2122caea480330ac40243e5acd7da06';

/// See also [appUserStream].
@ProviderFor(appUserStream)
const appUserStreamProvider = AppUserStreamFamily();

/// See also [appUserStream].
class AppUserStreamFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [appUserStream].
  const AppUserStreamFamily();

  /// See also [appUserStream].
  AppUserStreamProvider call(
    String uid,
  ) {
    return AppUserStreamProvider(
      uid,
    );
  }

  @override
  AppUserStreamProvider getProviderOverride(
    covariant AppUserStreamProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'appUserStreamProvider';
}

/// See also [appUserStream].
class AppUserStreamProvider extends AutoDisposeStreamProvider<AppUser?> {
  /// See also [appUserStream].
  AppUserStreamProvider(
    String uid,
  ) : this._internal(
          (ref) => appUserStream(
            ref as AppUserStreamRef,
            uid,
          ),
          from: appUserStreamProvider,
          name: r'appUserStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appUserStreamHash,
          dependencies: AppUserStreamFamily._dependencies,
          allTransitiveDependencies:
              AppUserStreamFamily._allTransitiveDependencies,
          uid: uid,
        );

  AppUserStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<AppUser?> Function(AppUserStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppUserStreamProvider._internal(
        (ref) => create(ref as AppUserStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AppUser?> createElement() {
    return _AppUserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppUserStreamProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AppUserStreamRef on AutoDisposeStreamProviderRef<AppUser?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _AppUserStreamProviderElement
    extends AutoDisposeStreamProviderElement<AppUser?> with AppUserStreamRef {
  _AppUserStreamProviderElement(super.provider);

  @override
  String get uid => (origin as AppUserStreamProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
