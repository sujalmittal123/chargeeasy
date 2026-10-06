import 'package:drift/drift.dart';
import '../app_database.dart';

part 'charger_dao.g.dart';

@DriftAccessor(tables: [Chargers])
class ChargerDao extends DatabaseAccessor<AppDatabase> with _$ChargerDaoMixin {
  ChargerDao(super.db);

  Future<List<Charger>> getAllChargers() => select(chargers).get();
  Future<int> insertCharger(ChargersCompanion charger) => into(chargers).insert(charger);
}
