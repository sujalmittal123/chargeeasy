class AiTipsEngineUseCase {
  List<String> execute({
    required double avgTempC,
    required int timesChargedTo100In7Days,
    required double chargerScore,
    required double healthPct,
    required double avgChargeSpeedDropPct,
    required double peakTempC,
  }) {
    List<String> tips = [];
    
    if (avgTempC > 38) {
      tips.add('Charging generates heat. Remove case while charging.');
    }
    if (timesChargedTo100In7Days > 5) {
      tips.add('Consider the 80% limit to extend battery life.');
    }
    if (chargerScore < 50) {
      tips.add('Your charger shows instability. Try a higher quality cable.');
    }
    if (healthPct < 80) {
      tips.add('Battery health declining. Consider replacement.');
    }
    if (avgChargeSpeedDropPct > 15) {
      tips.add('Charging speed dropped — check cable contacts.');
    }
    if (peakTempC > 45) {
      tips.add('Dangerously high temperatures detected. Avoid charging in hot environments.');
    }
    
    return tips;
  }
}
