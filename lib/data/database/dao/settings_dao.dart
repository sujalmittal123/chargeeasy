import 'package:drift/drift.dart';
import '../app_database.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<Setting?> getSetting(String key) =>
      (select(settings)..where((t) => t.key.equals(key))).getSingleOrNull();

  Future<void> setSetting(SettingsCompanion setting) =>
      into(settings).insertOnConflictUpdate(setting);

  /// Convenience: upsert a raw key-value pair.
  Future<void> upsertSetting(String key, String value) =>
      setSetting(SettingsCompanion(
        key: Value(key),
        value: Value(value),
      ),);

  Future<List<Setting>> getAllSettings() => select(settings).get();
}

