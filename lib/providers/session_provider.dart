import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/database/app_database.dart';
import '../data/repositories/session_repository.dart';
import 'settings_provider.dart';

part 'session_provider.g.dart';

// ── Session repository ────────────────────────────────────────────────────────
@Riverpod(keepAlive: true)
SessionRepository sessionRepository(SessionRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return SessionRepository(db.sessionDao);
}

// ── All sessions (last 100) ───────────────────────────────────────────────────
@riverpod
Future<List<Session>> sessions(SessionsRef ref) =>
    ref.watch(sessionRepositoryProvider).getAllSessions();

// ── Sessions paged (for history screen) ──────────────────────────────────────
@riverpod
Future<List<Session>> pagedSessions(
  PagedSessionsRef ref, {
  required int limit,
  required int offset,
}) =>
    ref.watch(sessionRepositoryProvider).getSessions(
          limit: limit,
          offset: offset,
        );
