import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
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
  RealColumn get avgMa => real().nullable()();
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
    final file = File(p.join(dbFolder.path, 'chargetracker_db.sqlite'));
    final oldFile = File(p.join(dbFolder.path, 'chargeeasy_db.sqlite'));
    if (!await file.exists() && await oldFile.exists()) {
      await oldFile.rename(file.path);
    }
    return NativeDatabase.createInBackground(file);
  });
}
