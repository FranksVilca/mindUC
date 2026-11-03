import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/profile_state.dart';
import '../../domain/entities/wellness_preferences.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/local_profile_datasource.dart';

/// Implementación del repositorio de perfil utilizando la fuente de datos local.
class LocalProfileRepositoryImpl implements ProfileRepository {
  final LocalProfileDataSource _dataSource;

  LocalProfileRepositoryImpl({LocalProfileDataSource? dataSource})
      : _dataSource = dataSource ?? LocalProfileDataSource();

  @override
  Future<Result<ProfileState, AppFailure>> getProfileState() async {
    try {
      final state = await _dataSource.getProfileState();
      return Success(state);
    } catch (e) {
      return FailureResult(
        CacheFailure('Error al cargar perfil del estudiante: $e'),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> updatePreferences(
      WellnessPreferences preferences) async {
    try {
      await _dataSource.updatePreferences(preferences);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Error al guardar preferencias de bienestar: $e'),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> logout() async {
    try {
      await _dataSource.logout();
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Error al cerrar sesión: $e'),
      );
    }
  }
}

