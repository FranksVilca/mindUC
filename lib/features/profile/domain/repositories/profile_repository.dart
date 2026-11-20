import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/profile_state.dart';
import '../entities/wellness_preferences.dart';

/// Contrato abstracto del repositorio de perfil y configuración (Principio I).
abstract class ProfileRepository {
  /// Obtiene el estado consolidado del perfil del estudiante según su identidad
  Future<Result<ProfileState, AppFailure>> getProfileState({
    String? userId,
    String? email,
    String? displayName,
    String? department,
    String? avatarUrl,
  });

  /// Actualiza las preferencias de bienestar consciente del usuario
  Future<Result<void, AppFailure>> updatePreferences(
    WellnessPreferences preferences, {
    String? userId,
  });

  /// Actualiza los datos de identidad y personales del perfil del estudiante
  Future<Result<void, AppFailure>> updateUserProfile({
    required String userId,
    required String fullName,
    required String career,
    required String universityEmail,
    String? avatarUrl,
  });

  /// Cierra la sesión en el dispositivo actual
  Future<Result<void, AppFailure>> logout({String? userId});
}
