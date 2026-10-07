class ComputeTimeEstimateUseCase {
  Duration? execute({
    required bool isCharging,
    required int currentPercent,
    required double ratePerMin,
  }) {
    if (ratePerMin <= 0) return null;
    
    if (isCharging) {
      int remaining = 100 - currentPercent;
      double mins = remaining / ratePerMin;
      return Duration(minutes: mins.round());
    } else {
      double mins = currentPercent / ratePerMin;
      return Duration(minutes: mins.round());
    }
  }

  /// Calculates dynamic time estimate directly from live current (mA) and device battery capacity (mAh).
  Duration? executeFromCurrent({
    required bool isCharging,
    required int currentPercent,
    required double currentMa,
    required int capacityMah,
  }) {
    if (capacityMah <= 0) return null;
    final absCurrent = currentMa.abs();
    if (absCurrent < 15.0) return null; // Negligible or zero current

    if (isCharging) {
      if (currentPercent >= 100) return Duration.zero;
      final neededMah = ((100 - currentPercent) / 100.0) * capacityMah;
      final hours = neededMah / absCurrent;
      final mins = (hours * 60).round().clamp(1, 48 * 60);
      return Duration(minutes: mins);
    } else {
      if (currentPercent <= 0) return Duration.zero;
      final remainingMah = (currentPercent / 100.0) * capacityMah;
      final hours = remainingMah / absCurrent;
      final mins = (hours * 60).round().clamp(1, 120 * 60);
      return Duration(minutes: mins);
    }
  }

  /// Calculates the real percentage rate per hour based on current drawn/received and capacity.
  double calculateRatePerHour({
    required double currentMa,
    required int capacityMah,
  }) {
    if (capacityMah <= 0) return 0.0;
    final absCurrent = currentMa.abs();
    if (absCurrent < 5.0) return 0.0;
    return (absCurrent / capacityMah) * 100.0;
  }
}
