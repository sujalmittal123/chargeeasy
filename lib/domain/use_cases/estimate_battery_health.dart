import 'dart:math';

class EstimateBatteryHealthUseCase {
  Map<String, dynamic> execute({
    required double chargeCounterUah,
    required int designCapacityMah,
    required double totalCumulativeDischargeMah,
  }) {
    double healthPct = min(100.0, (chargeCounterUah / 1000) / designCapacityMah * 100);
    int cycleCount = (totalCumulativeDischargeMah / designCapacityMah).floor();
    
    return {
      'healthPct': healthPct,
      'cycleCount': cycleCount,
    };
  }
}
