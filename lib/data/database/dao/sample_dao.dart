import 'package:drift/drift.dart';
import '../app_database.dart';

part 'sample_dao.g.dart';

@DriftAccessor(tables: [Samples])
class SampleDao extends DatabaseAccessor<AppDatabase> with _$SampleDaoMixin {
  SampleDao(super.db);

  Future<List<Sample>> getSamplesForSession(int sessionId) =>
      (select(samples)..where((t) => t.sessionId.equals(sessionId))).get();
  Future<int> insertSample(SamplesCompanion sample) => into(samples).insert(sample);
  
  Future<void> pruneOldSamples() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 90)).millisecondsSinceEpoch;
    await (delete(samples)..where((t) => t.ts.isSmallerThanValue(cutoff))).go();
  }
}
