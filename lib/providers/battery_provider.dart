import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/battery_reading.dart';
import '../data/repositories/battery_repository.dart';
import '../data/services/battery_service.dart';

part 'battery_provider.g.dart';

@riverpod
BatteryRepository batteryRepository(BatteryRepositoryRef ref) {
  return BatteryRepository(BatteryService());
}

@riverpod
Stream<BatteryReading> batteryStream(BatteryStreamRef ref) {
  return ref.watch(batteryRepositoryProvider).batteryStream;
}
