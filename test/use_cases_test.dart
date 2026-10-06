import 'package:flutter_test/flutter_test.dart';
import 'package:voltiq/domain/models/battery_reading.dart';
import 'package:voltiq/domain/use_cases/ai_tips_engine.dart';
import 'package:voltiq/domain/use_cases/compute_charger_score.dart';
import 'package:voltiq/domain/use_cases/compute_time_estimate.dart';
import 'package:voltiq/domain/use_cases/estimate_battery_health.dart';

void main() {
  group('ComputeChargerScoreUseCase', () {
    final useCase = ComputeChargerScoreUseCase();

    test('returns high score for stable, efficient, cool charger', () {
      final score = useCase.execute(
        wattsSamples: [24.8, 25.0, 25.1, 24.9, 25.0],
        ratedW: 25.0,
        maxTempC: 36.0,
      );
      expect(score, greaterThan(85.0));
      expect(score, lessThanOrEqualTo(100.0));
    });

    test('penalizes unstable charger with high temperature', () {
      final score = useCase.execute(
        wattsSamples: [5.0, 22.0, 8.0, 19.0, 6.0],
        ratedW: 25.0,
        maxTempC: 46.0, // > 45°C thermal penalty
      );
      expect(score, lessThan(70.0));
    });

    test('returns 0 for empty watts samples', () {
      final score = useCase.execute(
        wattsSamples: [],
        ratedW: 25.0,
        maxTempC: 35.0,
      );
      expect(score, 0.0);
    });
  });

  group('ComputeTimeEstimateUseCase', () {
    final useCase = ComputeTimeEstimateUseCase();

    test('estimates remaining charging time accurately', () {
      final duration = useCase.execute(
        isCharging: true,
        currentPercent: 80,
        ratePerMin: 1.0, // 20% remaining at 1%/min
      );
      expect(duration, isNotNull);
      expect(duration!.inMinutes, equals(20));
    });

    test('estimates remaining discharging time accurately', () {
      final duration = useCase.execute(
        isCharging: false,
        currentPercent: 50,
        ratePerMin: 0.25, // 50% at 0.25%/min = 200 min (~3h 20m)
      );
      expect(duration, isNotNull);
      expect(duration!.inMinutes, equals(200));
    });

    test('returns null when ratePerMin is zero or negative', () {
      final duration = useCase.execute(
        isCharging: true,
        currentPercent: 50,
        ratePerMin: 0.0,
      );
      expect(duration, isNull);
    });
  });

  group('EstimateBatteryHealthUseCase', () {
    final useCase = EstimateBatteryHealthUseCase();

    test('calculates health percentage and cycle count correctly', () {
      final result = useCase.execute(
        chargeCounterUah: 4600000.0, // 4600 mAh
        designCapacityMah: 5000,
        totalCumulativeDischargeMah: 1250000.0, // 1250000 / 5000 = 250 cycles
      );
      expect(result['healthPct'], closeTo(92.0, 0.1));
      expect(result['cycleCount'], equals(250));
    });
  });

  group('AiTipsEngineUseCase', () {
    final useCase = AiTipsEngineUseCase();

    test('generates overheat and 80% limit coaching tips', () {
      final tips = useCase.execute(
        avgTempC: 39.5,
        timesChargedTo100In7Days: 6,
        chargerScore: 88.0,
        healthPct: 95.0,
        avgChargeSpeedDropPct: 5.0,
        peakTempC: 46.0,
      );
      expect(tips, contains('Charging generates heat. Remove case while charging.'));
      expect(tips, contains('Consider the 80% limit to extend battery life.'));
      expect(tips, contains('Dangerously high temperatures detected. Avoid charging in hot environments.'));
    });
  });

  group('BatteryReading Model', () {
    test('computes powerW correctly and classifies charge speed labels', () {
      final reading = BatteryReading(
        currentMa: 3000,
        voltageMv: 4000,
        temperatureC: 32.5,
        percent: 50,
        status: BatteryStatus.charging,
        plugType: PlugType.ac,
        health: BatteryHealth.good,
        timestamp: DateTime.now(),
      );

      // 3000 * 4000 / 1,000,000 = 12.0 W
      expect(reading.powerW, closeTo(12.0, 0.01));
      expect(reading.chargeLevelLabel, equals('normal'));
    });

    test('detects fast and superFast charging wattage', () {
      final fastReading = BatteryReading(
        currentMa: 5000,
        voltageMv: 4400,
        temperatureC: 35.0,
        percent: 30,
        status: BatteryStatus.charging,
        plugType: PlugType.ac,
        health: BatteryHealth.good,
        timestamp: DateTime.now(),
      );
      // 5000 * 4400 / 1,000,000 = 22.0 W -> 'fast'
      expect(fastReading.powerW, closeTo(22.0, 0.01));
      expect(fastReading.chargeLevelLabel, equals('fast'));

      final superReading = BatteryReading(
        currentMa: 7500,
        voltageMv: 4400,
        temperatureC: 37.0,
        percent: 20,
        status: BatteryStatus.charging,
        plugType: PlugType.ac,
        health: BatteryHealth.good,
        timestamp: DateTime.now(),
      );
      // 7500 * 4400 / 1,000,000 = 33.0 W -> 'superFast'
      expect(superReading.powerW, closeTo(33.0, 0.01));
      expect(superReading.chargeLevelLabel, equals('superFast'));
    });
  });
}
