import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_report.freezed.dart';
part 'weekly_report.g.dart';

@freezed
class WeeklyReport with _$WeeklyReport {
  const factory WeeklyReport({
    required double avgSpeedW,
    required int timesChargedTo100,
    required int timesOverLimit,
    required double avgMaxTempC,
    required double totalChargeEnergyWh,
    required List<String> insights,
  }) = _WeeklyReport;

  factory WeeklyReport.fromJson(Map<String, dynamic> json) => _$WeeklyReportFromJson(json);
}
