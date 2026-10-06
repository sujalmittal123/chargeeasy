import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_drain_info.freezed.dart';
part 'app_drain_info.g.dart';

@freezed
class AppDrainInfo with _$AppDrainInfo {
  const factory AppDrainInfo({
    required String packageName,
    required String appName,
    required double energyConsumedMah,
    required double percentOfTotal,
  }) = _AppDrainInfo;

  factory AppDrainInfo.fromJson(Map<String, dynamic> json) => _$AppDrainInfoFromJson(json);
}
