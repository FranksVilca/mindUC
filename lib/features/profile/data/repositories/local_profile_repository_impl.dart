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
  Future<Result<ProfileState, AppFailure>> getProfileState({
    String? userId,
    String? email,
    String? displayName,
    String? department,
    String? avatarUrl,
  }) async {
    try {
      final state = await _dataSource.getProfileState(
        userId: userId,
        email: email,
        displayName: displayName,
        department: department,
        avatarUrl: avatarUrl,
      );
      return Success(state);
    } catch (e) {
      return FailureResult(
        CacheFailure('Error al cargar perfil del estudiante: $e'),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> updatePreferences(
    WellnessPreferences preferences, {
    String? userId,
  }) async {
    try {
      await _dataSource.updatePreferences(preferences, userId: userId);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Error al guardar preferencias de bienestar: $e'),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> updateUserProfile({
    required String userId,
    required String fullName,
    required String career,
    required String universityEmail,
    String? avatarUrl,
  }) async {
    try {
      await _dataSource.updateUserProfile(
        userId: userId,
        fullName: fullName,
        career: career,
        universityEmail: universityEmail,
        avatarUrl: avatarUrl,
      );
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Error al actualizar datos personales: $e'),
      );
    }
  }

  @override
  Future<Result<void, AppFailure>> logout({String? userId}) async {
    try {
      await _dataSource.logout(userId: userId);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        CacheFailure('Error al cerrar sesión: $e'),
      );
    }
  }
}
