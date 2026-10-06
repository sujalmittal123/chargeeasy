import '../database/dao/charger_dao.dart';
import '../database/app_database.dart';

class ChargerRepository {
  final ChargerDao _dao;
  
  ChargerRepository(this._dao);
  
  Future<List<Charger>> getAllChargers() => _dao.getAllChargers();
  Future<int> insertCharger(ChargersCompanion charger) => _dao.insertCharger(charger);
}
