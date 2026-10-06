import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content.strip() + '\n')

write_file('lib/data/database/app_database.dart', """
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/package_provider.dart';
import 'package:path/path.dart' as p;
import 'dao/session_dao.dart';
import 'dao/sample_dao.dart';
import 'dao/charger_dao.dart';
import 'dao/health_dao.dart';
import 'dao/settings_dao.dart';

part 'app_database.g.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get startTs => integer()();
  IntColumn get endTs => integer().nullable()();
  IntColumn get startPct => integer()();
  IntColumn get endPct => integer().nullable()();
  RealColumn get avgW => real().nullable()();
  RealColumn get peakW => real().nullable()();
  RealColumn get maxTemp => real().nullable()();
  IntColumn get chargerId => integer().nullable()();
  TextColumn get chargerType => text()();
}

class Samples extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer()();
  IntColumn get ts => integer()();
  RealColumn get ma => real()();
  RealColumn get mv => real()();
  RealColumn get temp => real()();
  IntColumn get pct => integer()();
}

class Chargers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get ratedW => real()();
  RealColumn get avgScore => real().nullable()();
  IntColumn get sessionsCount => integer().withDefault(const Constant(0))();
}

class HealthSnapshots extends Table {
  IntColumn get ts => integer()();
  IntColumn get estCapacityMah => integer()();
  RealColumn get healthPct => real()();
  IntColumn get cycleCount => integer()();
  @override
  Set<Column> get primaryKey => {ts};
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [Sessions, Samples, Chargers, HealthSnapshots, Settings],
  daos: [SessionDao, SampleDao, ChargerDao, HealthDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'voltiq_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
""")

write_file('lib/data/database/dao/session_dao.dart', """
import 'package:drift/drift.dart';
import '../app_database.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(AppDatabase db) : super(db);

  Future<List<Session>> getAllSessions() => select(sessions).get();
  Future<int> insertSession(SessionsCompanion session) => into(sessions).insert(session);
  Future<void> updateSession(Session session) => update(sessions).replace(session);
}
""")

write_file('lib/data/database/dao/sample_dao.dart', """
import 'package:drift/drift.dart';
import '../app_database.dart';

part 'sample_dao.g.dart';

@DriftAccessor(tables: [Samples])
class SampleDao extends DatabaseAccessor<AppDatabase> with _$SampleDaoMixin {
  SampleDao(AppDatabase db) : super(db);

  Future<List<Sample>> getSamplesForSession(int sessionId) =>
      (select(samples)..where((t) => t.sessionId.equals(sessionId))).get();
  Future<int> insertSample(SamplesCompanion sample) => into(samples).insert(sample);
  
  Future<void> pruneOldSamples() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 90)).millisecondsSinceEpoch;
    await (delete(samples)..where((t) => t.ts.isSmallerThanValue(cutoff))).go();
  }
}
""")

write_file('lib/data/database/dao/charger_dao.dart', """
import 'package:drift/drift.dart';
import '../app_database.dart';

part 'charger_dao.g.dart';

@DriftAccessor(tables: [Chargers])
class ChargerDao extends DatabaseAccessor<AppDatabase> with _$ChargerDaoMixin {
  ChargerDao(AppDatabase db) : super(db);

  Future<List<Charger>> getAllChargers() => select(chargers).get();
  Future<int> insertCharger(ChargersCompanion charger) => into(chargers).insert(charger);
}
""")

write_file('lib/data/database/dao/health_dao.dart', """
import 'package:drift/drift.dart';
import '../app_database.dart';

part 'health_dao.g.dart';

@DriftAccessor(tables: [HealthSnapshots])
class HealthDao extends DatabaseAccessor<AppDatabase> with _$HealthDaoMixin {
  HealthDao(AppDatabase db) : super(db);

  Future<List<HealthSnapshot>> getAllSnapshots() => select(healthSnapshots).get();
  Future<int> insertSnapshot(HealthSnapshotsCompanion snapshot) => into(healthSnapshots).insert(snapshot);
}
""")

write_file('lib/data/database/dao/settings_dao.dart', """
import 'package:drift/drift.dart';
import '../app_database.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(AppDatabase db) : super(db);

  Future<Setting?> getSetting(String key) =>
      (select(settings)..where((t) => t.key.equals(key))).getSingleOrNull();
  Future<void> setSetting(SettingsCompanion setting) =>
      into(settings).insertOnConflictUpdate(setting);
}
""")

write_file('lib/domain/models/battery_reading.dart', """
import 'package:freezed_annotation/freezed_annotation.dart';

part 'battery_reading.freezed.dart';
part 'battery_reading.g.dart';

enum BatteryStatus { charging, discharging, full, notCharging, unknown }
enum PlugType { ac, usb, wireless, none }
enum BatteryHealth { good, overheat, dead, overVoltage, unspecified }

@freezed
class BatteryReading with _$BatteryReading {
  const BatteryReading._();

  const factory BatteryReading({
    required double currentMa,
    required int voltageMv,
    required double temperatureC,
    required int percent,
    required BatteryStatus status,
    required PlugType plugType,
    required BatteryHealth health,
    required DateTime timestamp,
  }) = _BatteryReading;

  factory BatteryReading.fromJson(Map<String, dynamic> json) => _$BatteryReadingFromJson(json);

  double get powerW => (currentMa * voltageMv) / 1000000;
  
  String get chargeLevelLabel {
    if (powerW < 5) return 'slow';
    if (powerW < 15) return 'normal';
    if (powerW < 25) return 'fast';
    return 'superFast';
  }
}
""")

write_file('lib/domain/models/charging_session.dart', """
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
    double? maxTempC,
    int? chargerId,
    required String chargerType,
  }) = _ChargingSession;

  factory ChargingSession.fromJson(Map<String, dynamic> json) => _$ChargingSessionFromJson(json);
}
""")

write_file('lib/domain/models/charger_profile.dart', """
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
""")

write_file('lib/domain/models/health_snapshot.dart', """
import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_snapshot.freezed.dart';
part 'health_snapshot.g.dart';

@freezed
class HealthSnapshotModel with _$HealthSnapshotModel {
  const factory HealthSnapshotModel({
    required DateTime timestamp,
    required int estCapacityMah,
    required double healthPct,
    required int cycleCount,
  }) = _HealthSnapshotModel;

  factory HealthSnapshotModel.fromJson(Map<String, dynamic> json) => _$HealthSnapshotModelFromJson(json);
}
""")

write_file('lib/domain/models/alarm_config.dart', """
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_config.freezed.dart';
part 'alarm_config.g.dart';

@freezed
class AlarmConfig with _$AlarmConfig {
  const factory AlarmConfig({
    required bool enabled,
    required int targetPercent,
    required double maxTempC,
    required bool playSound,
    required bool vibrate,
  }) = _AlarmConfig;

  factory AlarmConfig.fromJson(Map<String, dynamic> json) => _$AlarmConfigFromJson(json);
}
""")

write_file('lib/domain/models/discharge_stats.dart', """
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discharge_stats.freezed.dart';
part 'discharge_stats.g.dart';

@freezed
class DischargeStats with _$DischargeStats {
  const factory DischargeStats({
    required double screenOnDrainPerHr,
    required double screenOffDrainPerHr,
    required double deepSleepDrainPerHr,
  }) = _DischargeStats;

  factory DischargeStats.fromJson(Map<String, dynamic> json) => _$DischargeStatsFromJson(json);
}
""")

write_file('lib/domain/models/weekly_report.dart', """
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
""")

write_file('lib/domain/models/app_drain_info.dart', """
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
""")

write_file('lib/domain/use_cases/compute_charger_score.dart', """
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
""")

write_file('lib/domain/use_cases/estimate_battery_health.dart', """
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
""")

write_file('lib/domain/use_cases/compute_time_estimate.dart', """
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
""")

write_file('lib/domain/use_cases/generate_weekly_report.dart', """
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
""")

write_file('lib/domain/use_cases/export_sessions.dart', """
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/database/app_database.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExportSessionsUseCase {
  Future<String> exportToCsv(List<Session> sessions) async {
    List<List<dynamic>> rows = [
      ['ID', 'Start', 'End', 'Start%', 'End%', 'AvgW', 'PeakW', 'MaxTemp', 'ChargerType']
    ];
    for (var s in sessions) {
      rows.add([
        s.id,
        s.startTs,
        s.endTs,
        s.startPct,
        s.endPct,
        s.avgW,
        s.peakW,
        s.maxTemp,
        s.chargerType,
      ]);
    }
    String csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('\${dir.path}/sessions_export.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  Future<String> exportToPdf(List<Session> sessions) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text("VoltIQ Sessions Report"),
        );
      },
    ));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('\${dir.path}/sessions_export.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
""")

write_file('lib/domain/use_cases/discharge_analytics.dart', """
import '../models/discharge_stats.dart';

class DischargeAnalyticsUseCase {
  DischargeStats execute() {
    return const DischargeStats(
      screenOnDrainPerHr: 12.5,
      screenOffDrainPerHr: 1.2,
      deepSleepDrainPerHr: 0.5,
    );
  }
}
""")

write_file('lib/domain/use_cases/ai_tips_engine.dart', """
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
""")

write_file('lib/data/repositories/battery_repository.dart', """
import '../services/battery_service.dart';
import '../../domain/models/battery_reading.dart';

class BatteryRepository {
  final BatteryService _batteryService;
  
  BatteryRepository(this._batteryService);
  
  Stream<BatteryReading> get batteryStream => _batteryService.batteryStream;
  
  Future<int> getDesignCapacity() => _batteryService.getDesignCapacity();
}
""")

write_file('lib/data/repositories/session_repository.dart', """
import '../database/dao/session_dao.dart';
import '../database/app_database.dart';

class SessionRepository {
  final SessionDao _dao;
  
  SessionRepository(this._dao);
  
  Future<List<Session>> getAllSessions() => _dao.getAllSessions();
}
""")

write_file('lib/data/repositories/health_repository.dart', """
import '../database/dao/health_dao.dart';
import '../database/app_database.dart';

class HealthRepository {
  final HealthDao _dao;
  
  HealthRepository(this._dao);
  
  Future<List<HealthSnapshot>> getAllSnapshots() => _dao.getAllSnapshots();
}
""")

write_file('lib/data/repositories/charger_repository.dart', """
import '../database/dao/charger_dao.dart';
import '../database/app_database.dart';

class ChargerRepository {
  final ChargerDao _dao;
  
  ChargerRepository(this._dao);
  
  Future<List<Charger>> getAllChargers() => _dao.getAllChargers();
}
""")

write_file('lib/data/repositories/settings_repository.dart', """
import '../database/dao/settings_dao.dart';
import '../database/app_database.dart';

class SettingsRepository {
  final SettingsDao _dao;
  
  SettingsRepository(this._dao);
  
  Future<Setting?> getSetting(String key) => _dao.getSetting(key);
}
""")

write_file('lib/data/services/battery_service.dart', """
import 'package:flutter/services.dart';
import '../../domain/models/battery_reading.dart';
import '../../domain/models/app_drain_info.dart';

class BatteryService {
  static const EventChannel _eventChannel = EventChannel('com.voltiq.app/battery_stream');
  static const MethodChannel _methodChannel = MethodChannel('com.voltiq.app/battery_commands');

  Stream<BatteryReading> get batteryStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event);
      return BatteryReading(
        currentMa: map['currentMa'] ?? 0.0,
        voltageMv: map['voltageMv'] ?? 0,
        temperatureC: map['temperatureC'] ?? 0.0,
        percent: map['percent'] ?? 0,
        status: BatteryStatus.values.firstWhere((e) => e.toString() == 'BatteryStatus.\${map['status']}'),
        plugType: PlugType.values.firstWhere((e) => e.toString() == 'PlugType.\${map['plugType']}'),
        health: BatteryHealth.values.firstWhere((e) => e.toString() == 'BatteryHealth.\${map['health']}'),
        timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch),
      );
    });
  }

  Future<int> getDesignCapacity() async {
    return await _methodChannel.invokeMethod<int>('getDesignCapacity') ?? 0;
  }

  Future<void> startForegroundService() async {
    await _methodChannel.invokeMethod('startForegroundService');
  }

  Future<void> stopForegroundService() async {
    await _methodChannel.invokeMethod('stopForegroundService');
  }

  Future<void> setGuardMode(bool enabled) async {
    await _methodChannel.invokeMethod('setGuardMode', {'enabled': enabled});
  }

  Future<void> setAlarms(Map<String, dynamic> config) async {
    await _methodChannel.invokeMethod('setAlarms', config);
  }

  Future<void> calibrateCurrentSign(bool isChargingPositive) async {
    await _methodChannel.invokeMethod('calibrateCurrentSign', {'isChargingPositive': isChargingPositive});
  }

  Future<List<AppDrainInfo>> getUsageStats() async {
    final List<dynamic>? result = await _methodChannel.invokeMethod<List<dynamic>>('getUsageStats');
    if (result == null) return [];
    return result.map((e) => AppDrainInfo.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> requestIgnoreBatteryOptimizations() async {
    await _methodChannel.invokeMethod('requestIgnoreBatteryOptimizations');
  }
}
""")

write_file('lib/data/services/notification_service.dart', """
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);
    
    // Create channels
    final androidChannel1 = AndroidNotificationChannel(
      'charging_monitor',
      'Charging Monitor',
      description: 'Shows live charging stats',
      importance: Importance.low,
    );
    final androidChannel2 = AndroidNotificationChannel(
      'alarms',
      'Battery Alarms',
      description: 'Alerts for temperature and charge level',
      importance: Importance.high,
    );
    final androidChannel3 = AndroidNotificationChannel(
      'guard_mode',
      'Guard Mode',
      description: 'Theft alarm',
      importance: Importance.max,
    );
    
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel1);
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel2);
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel3);
  }

  Future<void> showNotification(int id, String title, String body, String channelId) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId,
          importance: Importance.high,
        ),
      ),
    );
  }
}
""")

write_file('lib/data/services/widget_service.dart', """
import 'package:home_widget/home_widget.dart';

class WidgetService {
  Future<void> updateWidgetData(Map<String, dynamic> data) async {
    for (var entry in data.entries) {
      await HomeWidget.saveWidgetData<String>(entry.key, entry.value.toString());
    }
    await HomeWidget.updateWidget(name: 'BatteryWidget2x1');
    await HomeWidget.updateWidget(name: 'BatteryWidget4x2');
  }
}
""")

write_file('lib/providers/battery_provider.dart', """
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/battery_reading.dart';
import '../data/repositories/battery_repository.dart';
import '../data/services/battery_service.dart';

part 'battery_provider.g.dart';

@riverpod
BatteryRepository batteryRepository(BatteryRepositoryRef ref) {
  return BatteryRepository(BatteryService());
}

@riverpod
Stream<BatteryReading> batteryStream(BatteryStreamRef ref) {
  return ref.watch(batteryRepositoryProvider).batteryStream;
}
""")

write_file('lib/providers/session_provider.dart', """
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/session_repository.dart';
import '../data/database/app_database.dart';
import 'package:get_it/get_it.dart'; // Using GetIt as example or you can provide db

part 'session_provider.g.dart';

@riverpod
SessionRepository sessionRepository(SessionRepositoryRef ref) {
  // Assuming AppDatabase is a singleton or provided elsewhere
  return SessionRepository(AppDatabase().sessionDao);
}

@riverpod
Future<List<Session>> sessions(SessionsRef ref) {
  return ref.watch(sessionRepositoryProvider).getAllSessions();
}
""")

write_file('lib/providers/health_provider.dart', """
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/health_repository.dart';
import '../data/database/app_database.dart';

part 'health_provider.g.dart';

@riverpod
HealthRepository healthRepository(HealthRepositoryRef ref) {
  return HealthRepository(AppDatabase().healthDao);
}

@riverpod
Future<List<HealthSnapshot>> healthSnapshots(HealthSnapshotsRef ref) {
  return ref.watch(healthRepositoryProvider).getAllSnapshots();
}
""")

write_file('lib/providers/settings_provider.dart', """
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/settings_repository.dart';
import '../data/database/app_database.dart';

part 'settings_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepository(AppDatabase().settingsDao);
}

@riverpod
Future<Setting?> setting(SettingRef ref, String key) {
  return ref.watch(settingsRepositoryProvider).getSetting(key);
}
""")

write_file('lib/providers/pro_provider.dart', """
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pro_provider.g.dart';

@riverpod
class ProStatus extends _$ProStatus {
  @override
  bool build() {
    return false; // Free version by default
  }

  void upgrade() {
    state = true;
  }
}
""")

write_file('lib/providers/charger_provider.dart', """
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/charger_repository.dart';
import '../data/database/app_database.dart';

part 'charger_provider.g.dart';

@riverpod
ChargerRepository chargerRepository(ChargerRepositoryRef ref) {
  return ChargerRepository(AppDatabase().chargerDao);
}

@riverpod
Future<List<Charger>> chargers(ChargersRef ref) {
  return ref.watch(chargerRepositoryProvider).getAllChargers();
}
""")
