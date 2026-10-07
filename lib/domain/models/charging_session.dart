import 'package:freezed_annotation/freezed_annotation.dart';

part 'charging_session.freezed.dart';
part 'charging_session.g.dart';

@freezed
class ChargingSession with _$ChargingSession {
  const factory ChargingSession({
    required int id,
    required DateTime startTime,
    DateTime? endTime,
    required int startPercent,
    int? endPercent,
    double? avgPowerW,
    double? peakPowerW,
    double? avgMa,
    double? maxTempC,
    int? chargerId,
    required String chargerType,
  }) = _ChargingSession;

  factory ChargingSession.fromJson(Map<String, dynamic> json) => _$ChargingSessionFromJson(json);
}
