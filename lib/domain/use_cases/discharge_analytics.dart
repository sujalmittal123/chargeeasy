import '../models/discharge_stats.dart';

class DischargeAnalyticsUseCase {
  DischargeStats execute() {
    return const DischargeStats(
      screenOnDrainPerHr: 12.5,
      screenOffDrainPerHr: 1.2,
      deepSleepDrainPerHr: 0.5,
    );
  }
}
