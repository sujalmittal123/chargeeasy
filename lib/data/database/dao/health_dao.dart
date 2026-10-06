import 'package:drift/drift.dart';
import '../app_database.dart';

part 'health_dao.g.dart';

@DriftAccessor(tables: [HealthSnapshots])
class HealthDao extends DatabaseAccessor<AppDatabase> with _$HealthDaoMixin {
  HealthDao(super.db);

  Future<List<HealthSnapshot>> getAllSnapshots() => select(healthSnapshots).get();
  Future<int> insertSnapshot(HealthSnapshotsCompanion snapshot) => into(healthSnapshots).insert(snapshot);
}
