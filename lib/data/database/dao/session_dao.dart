import 'package:drift/drift.dart';
import '../app_database.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<AppDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Future<List<Session>> getAllSessions() => select(sessions).get();
  Future<List<Session>> getSessions({required int limit, required int offset}) =>
      (select(sessions)..limit(limit, offset: offset)).get();
  Future<Session?> getSessionById(int id) =>
      (select(sessions)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  Future<int> insertSession(SessionsCompanion session) => into(sessions).insert(session);
  Future<void> updateSession(Session session) => update(sessions).replace(session);
}
