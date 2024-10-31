// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_prompts_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPromptsRepositoryHash() =>
    r'a1989c8f8d04efbe2bdabb4bd1622bb7eb854102';

/// See also [userPromptsRepository].
@ProviderFor(userPromptsRepository)
final userPromptsRepositoryProvider = Provider<UserPromptsRepository>.internal(
  userPromptsRepository,
  name: r'userPromptsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPromptsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserPromptsRepositoryRef = ProviderRef<UserPromptsRepository>;
String _$userPromptStreamHash() => r'9d98fc6b6b46e18eed05f05a84dd55a48a37165e';

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

/// See also [userPromptStream].
@ProviderFor(userPromptStream)
const userPromptStreamProvider = UserPromptStreamFamily();

/// See also [userPromptStream].
class UserPromptStreamFamily extends Family<AsyncValue<UserPrompt?>> {
  /// See also [userPromptStream].
  const UserPromptStreamFamily();

  /// See also [userPromptStream].
  UserPromptStreamProvider call(
    String id,
  ) {
    return UserPromptStreamProvider(
      id,
    );
  }

  @override
  UserPromptStreamProvider getProviderOverride(
    covariant UserPromptStreamProvider provider,
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
  String? get name => r'userPromptStreamProvider';
}

/// See also [userPromptStream].
class UserPromptStreamProvider extends StreamProvider<UserPrompt?> {
  /// See also [userPromptStream].
  UserPromptStreamProvider(
    String id,
  ) : this._internal(
          (ref) => userPromptStream(
            ref as UserPromptStreamRef,
            id,
          ),
          from: userPromptStreamProvider,
          name: r'userPromptStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPromptStreamHash,
          dependencies: UserPromptStreamFamily._dependencies,
          allTransitiveDependencies:
              UserPromptStreamFamily._allTransitiveDependencies,
          id: id,
        );

  UserPromptStreamProvider._internal(
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
    Stream<UserPrompt?> Function(UserPromptStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserPromptStreamProvider._internal(
        (ref) => create(ref as UserPromptStreamRef),
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
  StreamProviderElement<UserPrompt?> createElement() {
    return _UserPromptStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPromptStreamProvider && other.id == id;
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
mixin UserPromptStreamRef on StreamProviderRef<UserPrompt?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _UserPromptStreamProviderElement
    extends StreamProviderElement<UserPrompt?> with UserPromptStreamRef {
  _UserPromptStreamProviderElement(super.provider);

  @override
  String get id => (origin as UserPromptStreamProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
