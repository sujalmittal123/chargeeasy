// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charger_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chargerRepositoryHash() => r'404d00d31fab4c44e8a49007fb927f650c0db79f';

/// See also [chargerRepository].
@ProviderFor(chargerRepository)
final chargerRepositoryProvider = Provider<ChargerRepository>.internal(
  chargerRepository,
  name: r'chargerRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chargerRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChargerRepositoryRef = ProviderRef<ChargerRepository>;
String _$chargersHash() => r'b3628b1a2f6d3343fdd10c1afbe5745c019cfaf1';

/// See also [chargers].
@ProviderFor(chargers)
final chargersProvider = AutoDisposeFutureProvider<List<Charger>>.internal(
  chargers,
  name: r'chargersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chargersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChargersRef = AutoDisposeFutureProviderRef<List<Charger>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
