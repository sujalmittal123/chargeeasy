// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$batteryRepositoryHash() => r'4ef7bcc1f0bca795cd725b395aaf4e2cf90a07e6';

/// See also [batteryRepository].
@ProviderFor(batteryRepository)
final batteryRepositoryProvider =
    AutoDisposeProvider<BatteryRepository>.internal(
  batteryRepository,
  name: r'batteryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$batteryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BatteryRepositoryRef = AutoDisposeProviderRef<BatteryRepository>;
String _$batteryStreamHash() => r'b21779b8cd430ebd69c5884619ef6b9ed794cd76';

/// See also [batteryStream].
@ProviderFor(batteryStream)
final batteryStreamProvider =
    AutoDisposeStreamProvider<BatteryReading>.internal(
  batteryStream,
  name: r'batteryStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$batteryStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BatteryStreamRef = AutoDisposeStreamProviderRef<BatteryReading>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
