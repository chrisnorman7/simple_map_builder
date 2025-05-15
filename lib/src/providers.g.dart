// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameMapsHash() => r'a2a4c0581c1f3a8e21abf385a8a85f7e46a25d62';

/// Provide all the created maps.
///
/// Copied from [gameMaps].
@ProviderFor(gameMaps)
final gameMapsProvider = AutoDisposeFutureProvider<List<GameMap>>.internal(
  gameMaps,
  name: r'gameMapsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameMapsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameMapsRef = AutoDisposeFutureProviderRef<List<GameMap>>;
String _$gameMapHash() => r'ee2c35620151804e41265c339b69e3475dc699ad';

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

/// Provide a single map.
///
/// Copied from [gameMap].
@ProviderFor(gameMap)
const gameMapProvider = GameMapFamily();

/// Provide a single map.
///
/// Copied from [gameMap].
class GameMapFamily extends Family<AsyncValue<GameMap>> {
  /// Provide a single map.
  ///
  /// Copied from [gameMap].
  const GameMapFamily();

  /// Provide a single map.
  ///
  /// Copied from [gameMap].
  GameMapProvider call(String id) {
    return GameMapProvider(id);
  }

  @override
  GameMapProvider getProviderOverride(covariant GameMapProvider provider) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gameMapProvider';
}

/// Provide a single map.
///
/// Copied from [gameMap].
class GameMapProvider extends AutoDisposeFutureProvider<GameMap> {
  /// Provide a single map.
  ///
  /// Copied from [gameMap].
  GameMapProvider(String id)
    : this._internal(
        (ref) => gameMap(ref as GameMapRef, id),
        from: gameMapProvider,
        name: r'gameMapProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$gameMapHash,
        dependencies: GameMapFamily._dependencies,
        allTransitiveDependencies: GameMapFamily._allTransitiveDependencies,
        id: id,
      );

  GameMapProvider._internal(
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
    FutureOr<GameMap> Function(GameMapRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GameMapProvider._internal(
        (ref) => create(ref as GameMapRef),
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
  AutoDisposeFutureProviderElement<GameMap> createElement() {
    return _GameMapProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameMapProvider && other.id == id;
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
mixin GameMapRef on AutoDisposeFutureProviderRef<GameMap> {
  /// The parameter `id` of this provider.
  String get id;
}

class _GameMapProviderElement extends AutoDisposeFutureProviderElement<GameMap>
    with GameMapRef {
  _GameMapProviderElement(super.provider);

  @override
  String get id => (origin as GameMapProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
