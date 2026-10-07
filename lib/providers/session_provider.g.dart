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

String _$sessionDetailHash() => r'd17a8eda2930f8a0fea625102df1adbc2ad98929';

/// See also [sessionDetail].
@ProviderFor(sessionDetail)
const sessionDetailProvider = SessionDetailFamily();

/// See also [sessionDetail].
class SessionDetailFamily extends Family<AsyncValue<Session?>> {
  /// See also [sessionDetail].
  const SessionDetailFamily();

  /// See also [sessionDetail].
  SessionDetailProvider call(
    int id,
  ) {
    return SessionDetailProvider(
      id,
    );
  }

  @override
  SessionDetailProvider getProviderOverride(
    covariant SessionDetailProvider provider,
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
  String? get name => r'sessionDetailProvider';
}

/// See also [sessionDetail].
class SessionDetailProvider extends AutoDisposeFutureProvider<Session?> {
  /// See also [sessionDetail].
  SessionDetailProvider(
    int id,
  ) : this._internal(
          (ref) => sessionDetail(
            ref as SessionDetailRef,
            id,
          ),
          from: sessionDetailProvider,
          name: r'sessionDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionDetailHash,
          dependencies: SessionDetailFamily._dependencies,
          allTransitiveDependencies:
              SessionDetailFamily._allTransitiveDependencies,
          id: id,
        );

  SessionDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Session?> Function(SessionDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionDetailProvider._internal(
        (ref) => create(ref as SessionDetailRef),
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
  AutoDisposeFutureProviderElement<Session?> createElement() {
    return _SessionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SessionDetailRef on AutoDisposeFutureProviderRef<Session?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _SessionDetailProviderElement
    extends AutoDisposeFutureProviderElement<Session?> with SessionDetailRef {
  _SessionDetailProviderElement(super.provider);

  @override
  int get id => (origin as SessionDetailProvider).id;
}

String _$sessionSamplesHash() => r'14460718a5ee2a33a8e3d5727342bc2447e242c6';

/// See also [sessionSamples].
@ProviderFor(sessionSamples)
const sessionSamplesProvider = SessionSamplesFamily();

/// See also [sessionSamples].
class SessionSamplesFamily extends Family<AsyncValue<List<Sample>>> {
  /// See also [sessionSamples].
  const SessionSamplesFamily();

  /// See also [sessionSamples].
  SessionSamplesProvider call(
    int sessionId,
  ) {
    return SessionSamplesProvider(
      sessionId,
    );
  }

  @override
  SessionSamplesProvider getProviderOverride(
    covariant SessionSamplesProvider provider,
  ) {
    return call(
      provider.sessionId,
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
  String? get name => r'sessionSamplesProvider';
}

/// See also [sessionSamples].
class SessionSamplesProvider extends AutoDisposeFutureProvider<List<Sample>> {
  /// See also [sessionSamples].
  SessionSamplesProvider(
    int sessionId,
  ) : this._internal(
          (ref) => sessionSamples(
            ref as SessionSamplesRef,
            sessionId,
          ),
          from: sessionSamplesProvider,
          name: r'sessionSamplesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionSamplesHash,
          dependencies: SessionSamplesFamily._dependencies,
          allTransitiveDependencies:
              SessionSamplesFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  SessionSamplesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final int sessionId;

  @override
  Override overrideWith(
    FutureOr<List<Sample>> Function(SessionSamplesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionSamplesProvider._internal(
        (ref) => create(ref as SessionSamplesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Sample>> createElement() {
    return _SessionSamplesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionSamplesProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SessionSamplesRef on AutoDisposeFutureProviderRef<List<Sample>> {
  /// The parameter `sessionId` of this provider.
  int get sessionId;
}

class _SessionSamplesProviderElement
    extends AutoDisposeFutureProviderElement<List<Sample>>
    with SessionSamplesRef {
  _SessionSamplesProviderElement(super.provider);

  @override
  int get sessionId => (origin as SessionSamplesProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
