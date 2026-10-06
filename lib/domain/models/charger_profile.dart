import 'package:freezed_annotation/freezed_annotation.dart';

part 'charger_profile.freezed.dart';
part 'charger_profile.g.dart';

@freezed
class ChargerProfile with _$ChargerProfile {
  const factory ChargerProfile({
    required int id,
    required String name,
    required double ratedW,
    double? avgScore,
    required int sessionsCount,
  }) = _ChargerProfile;

  factory ChargerProfile.fromJson(Map<String, dynamic> json) => _$ChargerProfileFromJson(json);
}
