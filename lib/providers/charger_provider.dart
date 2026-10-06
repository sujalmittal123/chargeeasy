import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/database/app_database.dart';
import '../data/repositories/charger_repository.dart';
import 'settings_provider.dart';

part 'charger_provider.g.dart';

@Riverpod(keepAlive: true)
ChargerRepository chargerRepository(ChargerRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ChargerRepository(db.chargerDao);
}

@riverpod
Future<List<Charger>> chargers(ChargersRef ref) {
  return ref.watch(chargerRepositoryProvider).getAllChargers();
}
