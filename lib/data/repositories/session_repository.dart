import '../database/dao/session_dao.dart';
import '../database/app_database.dart';

class SessionRepository {
  final SessionDao _dao;
  
  SessionRepository(this._dao);
  
  Future<List<Session>> getAllSessions() => _dao.getAllSessions();
  Future<List<Session>> getSessions({required int limit, required int offset}) =>
      _dao.getSessions(limit: limit, offset: offset);
  Future<Session?> getSessionById(int id) => _dao.getSessionById(id);
  Future<int> insertSession(SessionsCompanion session) => _dao.insertSession(session);
  Future<void> updateSession(Session session) => _dao.updateSession(session);
}
