// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$healthRepositoryHash() => r'44dfabfd5ae7cbfc22a8711adc9cbc0e174d7ace';

/// See also [healthRepository].
@ProviderFor(healthRepository)
final healthRepositoryProvider = Provider<HealthRepository>.internal(
  healthRepository,
  name: r'healthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$healthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HealthRepositoryRef = ProviderRef<HealthRepository>;
String _$healthSnapshotsHash() => r'cd92efd17cebd4fc1ccb2cd64ddda1767d57cfb0';

/// See also [healthSnapshots].
@ProviderFor(healthSnapshots)
final healthSnapshotsProvider =
    AutoDisposeFutureProvider<List<HealthSnapshot>>.internal(
  healthSnapshots,
  name: r'healthSnapshotsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$healthSnapshotsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HealthSnapshotsRef = AutoDisposeFutureProviderRef<List<HealthSnapshot>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
