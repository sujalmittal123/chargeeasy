import '../models/weekly_report.dart';
import '../../data/database/app_database.dart';

class GenerateWeeklyReportUseCase {
  WeeklyReport execute({required List<Session> sessions}) {
    if (sessions.isEmpty) {
      return const WeeklyReport(
        avgSpeedW: 0,
        timesChargedTo100: 0,
        timesOverLimit: 0,
        avgMaxTempC: 0,
        totalChargeEnergyWh: 0,
        insights: ['No data available for the past week.'],
      );
    }

    double totalSpeed = 0;
    int timesTo100 = 0;
    int timesOverLimit = 0;
    double totalMaxTemp = 0;
    double totalEnergy = 0;

    for (var s in sessions) {
      totalSpeed += s.avgW ?? 0;
      if (s.endPct == 100) timesTo100++;
      if ((s.endPct ?? 0) > 80) timesOverLimit++;
      totalMaxTemp += s.maxTemp ?? 0;
      totalEnergy += ((s.avgW ?? 0) * ((s.endTs ?? 0) - s.startTs)) / 3600000;
    }

    return WeeklyReport(
      avgSpeedW: totalSpeed / sessions.length,
      timesChargedTo100: timesTo100,
      timesOverLimit: timesOverLimit,
      avgMaxTempC: totalMaxTemp / sessions.length,
      totalChargeEnergyWh: totalEnergy,
      insights: ['Good charging habits!'],
    );
  }
}
