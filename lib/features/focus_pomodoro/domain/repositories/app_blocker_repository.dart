import '../entities/app_blocker_status.dart';
import '../entities/blocked_app.dart';

/// Contrato de repositorio para gestionar el bloqueo de aplicaciones y permisos de SO.
abstract class AppBlockerRepository {
  /// Obtiene la lista completa de aplicaciones disponibles para bloquear.
  Future<List<BlockedApp>> getAvailableApps(String userId);

  /// Obtiene únicamente las aplicaciones que el usuario ha seleccionado para bloquear.
  Future<List<BlockedApp>> getBlockedApps(String userId);

  /// Guarda la selección de aplicaciones a bloquear para el usuario especificado.
  Future<void> saveBlockedApps(String userId, List<BlockedApp> apps);

  /// Verifica el estado de permisos y compatibilidad de la plataforma actual.
  Future<BlockerPermissionStatus> checkPermissionStatus({required bool isEnabled});

  /// Solicita los permisos necesarios del sistema operativo (en plataformas compatibles).
  Future<bool> requestPermissions();

  /// Establece el estado de activación del bloqueo de aplicaciones.
  Future<void> setBlockerActive(String userId, bool active, {int durationMinutes = 25});

  /// Consulta si el bloqueo está activo para el usuario.
  Future<bool> isBlockerActive(String userId);

  /// Obtiene la duración configurada para el bloqueo en minutos.
  Future<int> getBlockingDuration(String userId);

  /// Guarda la duración configurada para el bloqueo en minutos.
  Future<void> saveBlockingDuration(String userId, int minutes);
}
