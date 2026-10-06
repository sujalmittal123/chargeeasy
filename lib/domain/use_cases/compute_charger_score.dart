import 'dart:math';

class ComputeChargerScoreUseCase {
  double execute({
    required List<double> wattsSamples,
    required double ratedW,
    required double maxTempC,
  }) {
    if (wattsSamples.isEmpty) return 0.0;
    
    double actualAvgW = wattsSamples.reduce((a, b) => a + b) / wattsSamples.length;
    double efficiencyScore = (actualAvgW / ratedW) * 60.0;
    
    double mean = actualAvgW;
    double variance = wattsSamples.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / wattsSamples.length;
    double stdDev = sqrt(variance);
    double stabilityPenalty = stdDev * 2.0;
    
    double heatPenalty = 0.0;
    if (maxTempC > 45) {
      heatPenalty = 15.0;
    } else if (maxTempC > 40) {
      heatPenalty = 5.0;
    }
    
    double score = 100.0 - stabilityPenalty - heatPenalty - (60.0 - efficiencyScore);
    return max(0.0, min(100.0, score));
  }
}
