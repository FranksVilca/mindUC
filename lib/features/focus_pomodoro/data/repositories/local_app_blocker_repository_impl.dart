import '../../domain/entities/app_blocker_status.dart';
import '../../domain/entities/blocked_app.dart';
import '../../domain/repositories/app_blocker_repository.dart';
import '../datasources/local_app_blocker_datasource.dart';

/// Implementación del repositorio de bloqueo de aplicaciones que delega
/// en el datasource local y verifica las capacidades de la plataforma.
class LocalAppBlockerRepositoryImpl implements AppBlockerRepository {
  LocalAppBlockerRepositoryImpl({LocalAppBlockerDatasource? datasource})
      : _datasource = datasource ?? LocalAppBlockerDatasource();

  final LocalAppBlockerDatasource _datasource;

  @override
  Future<List<BlockedApp>> getAvailableApps(String userId) {
    return _datasource.getAvailableApps(userId);
  }

  @override
  Future<List<BlockedApp>> getBlockedApps(String userId) {
    return _datasource.getBlockedApps(userId);
  }

  @override
  Future<void> saveBlockedApps(String userId, List<BlockedApp> apps) {
    return _datasource.saveBlockedApps(userId, apps);
  }

  @override
  Future<BlockerPermissionStatus> checkPermissionStatus({
    required bool isEnabled,
  }) {
    return _datasource.checkPermissionStatus(isEnabled: isEnabled);
  }

  @override
  Future<bool> requestPermissions() {
    return _datasource.requestPermissions();
  }

  @override
  Future<void> setBlockerActive(
    String userId,
    bool active, {
    int durationMinutes = 25,
  }) {
    return _datasource.setBlockerActive(
      userId,
      active,
      durationMinutes: durationMinutes,
    );
  }

  @override
  Future<bool> isBlockerActive(String userId) {
    return _datasource.isBlockerActive(userId);
  }

  @override
  Future<int> getBlockingDuration(String userId) {
    return _datasource.getBlockingDuration(userId);
  }

  @override
  Future<void> saveBlockingDuration(String userId, int minutes) {
    return _datasource.saveBlockingDuration(userId, minutes);
  }
}
