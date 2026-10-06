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
}
