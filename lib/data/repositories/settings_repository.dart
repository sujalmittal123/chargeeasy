import '../database/dao/settings_dao.dart';

class SettingsRepository {
  final SettingsDao _dao;
  SettingsRepository(this._dao);

  /// Get a value by key, returns null if not set.
  Future<String?> get(String key) async {
    final row = await _dao.getSetting(key);
    return row?.value;
  }

  /// Persist a key-value pair.
  Future<void> set(String key, String value) =>
      _dao.upsertSetting(key, value);

  /// Convenience: get and parse as int.
  Future<int?> getInt(String key) async {
    final v = await get(key);
    return v == null ? null : int.tryParse(v);
  }

  /// Convenience: get and parse as double.
  Future<double?> getDouble(String key) async {
    final v = await get(key);
    return v == null ? null : double.tryParse(v);
  }

  /// Convenience: get and parse as bool.
  Future<bool?> getBool(String key) async {
    final v = await get(key);
    return v == null ? null : v == 'true';
  }
}
