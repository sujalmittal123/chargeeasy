import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/database/app_database.dart';
import '../data/repositories/health_repository.dart';
import 'settings_provider.dart';

part 'health_provider.g.dart';

@Riverpod(keepAlive: true)
HealthRepository healthRepository(HealthRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return HealthRepository(db.healthDao);
}

@riverpod
Future<List<HealthSnapshot>> healthSnapshots(HealthSnapshotsRef ref) {
  return ref.watch(healthRepositoryProvider).getAllSnapshots();
}
