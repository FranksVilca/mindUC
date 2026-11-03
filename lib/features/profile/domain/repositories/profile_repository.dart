import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/profile_state.dart';
import '../entities/wellness_preferences.dart';

/// Contrato abstracto del repositorio de perfil y configuración (Principio I).
abstract class ProfileRepository {
  /// Obtiene el estado consolidado del perfil del estudiante
  Future<Result<ProfileState, AppFailure>> getProfileState();

  /// Actualiza las preferencias de bienestar consciente
  Future<Result<void, AppFailure>> updatePreferences(WellnessPreferences preferences);

  /// Cierra la sesión en el dispositivo actual
  Future<Result<void, AppFailure>> logout();
}

