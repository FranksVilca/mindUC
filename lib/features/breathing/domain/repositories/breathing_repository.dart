import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/breathing_session_log.dart';

/// Contrato abstracto del repositorio para la persistencia del historial de respiración.
abstract class BreathingRepository {
  /// Registra una sesión de respiración consciente completada.
  Future<Result<BreathingSessionLog, AppFailure>> saveSession(
    BreathingSessionLog log,
  );

  /// Recupera el historial de sesiones del usuario.
  Future<Result<List<BreathingSessionLog>, AppFailure>> getUserSessions(
    String userId,
  );
}
