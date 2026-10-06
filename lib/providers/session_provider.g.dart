// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionRepositoryHash() => r'3b765b05521d2d4ecf54a1ea100461e2342238ca';

/// See also [sessionRepository].
@ProviderFor(sessionRepository)
final sessionRepositoryProvider = Provider<SessionRepository>.internal(
  sessionRepository,
  name: r'sessionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionRepositoryRef = ProviderRef<SessionRepository>;
String _$sessionsHash() => r'3da31a163981c8da14bcc5e765af4e906f54a893';

/// See also [sessions].
@ProviderFor(sessions)
final sessionsProvider = AutoDisposeFutureProvider<List<Session>>.internal(
  sessions,
  name: r'sessionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sessionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SessionsRef = AutoDisposeFutureProviderRef<List<Session>>;
String _$pagedSessionsHash() => r'304efce9cd8745a91c9b15c15865059f769e333e';

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

/// See also [pagedSessions].
@ProviderFor(pagedSessions)
const pagedSessionsProvider = PagedSessionsFamily();

/// See also [pagedSessions].
class PagedSessionsFamily extends Family<AsyncValue<List<Session>>> {
  /// See also [pagedSessions].
  const PagedSessionsFamily();

  /// See also [pagedSessions].
  PagedSessionsProvider call({
    required int limit,
    required int offset,
  }) {
    return PagedSessionsProvider(
      limit: limit,
      offset: offset,
    );
  }

  @override
  PagedSessionsProvider getProviderOverride(
    covariant PagedSessionsProvider provider,
  ) {
    return call(
      limit: provider.limit,
      offset: provider.offset,
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
  String? get name => r'pagedSessionsProvider';
}

/// See also [pagedSessions].
class PagedSessionsProvider extends AutoDisposeFutureProvider<List<Session>> {
  /// See also [pagedSessions].
  PagedSessionsProvider({
    required int limit,
    required int offset,
  }) : this._internal(
          (ref) => pagedSessions(
            ref as PagedSessionsRef,
            limit: limit,
            offset: offset,
          ),
          from: pagedSessionsProvider,
          name: r'pagedSessionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pagedSessionsHash,
          dependencies: PagedSessionsFamily._dependencies,
          allTransitiveDependencies:
              PagedSessionsFamily._allTransitiveDependencies,
          limit: limit,
          offset: offset,
        );

  PagedSessionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
    required this.offset,
  }) : super.internal();

  final int limit;
  final int offset;

  @override
  Override overrideWith(
    FutureOr<List<Session>> Function(PagedSessionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PagedSessionsProvider._internal(
        (ref) => create(ref as PagedSessionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Session>> createElement() {
    return _PagedSessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PagedSessionsProvider &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PagedSessionsRef on AutoDisposeFutureProviderRef<List<Session>> {
  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _PagedSessionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Session>>
    with PagedSessionsRef {
  _PagedSessionsProviderElement(super.provider);

  @override
  int get limit => (origin as PagedSessionsProvider).limit;
  @override
  int get offset => (origin as PagedSessionsProvider).offset;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
