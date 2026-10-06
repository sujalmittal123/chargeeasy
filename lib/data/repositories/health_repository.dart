import '../database/dao/health_dao.dart';
import '../database/app_database.dart';

class HealthRepository {
  final HealthDao _dao;
  
  HealthRepository(this._dao);
  
  Future<List<HealthSnapshot>> getAllSnapshots() => _dao.getAllSnapshots();
}
