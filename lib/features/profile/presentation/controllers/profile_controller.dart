import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/institutional_support_contact.dart';
import '../../domain/entities/profile_state.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/wellness_preferences.dart';
import '../../domain/repositories/profile_repository.dart';

/// Proveedor del repositorio de perfil con soporte Cloud Firestore y respaldo local.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

/// Proveedor del controlador de perfil reactivo al usuario autenticado.
final profileControllerProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  return ProfileNotifier(
    repository: repository,
    currentUser: currentUser,
  );
});

/// Controlador reactivo del perfil y preferencias conscientes del estudiante.
class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;
  final UserEntity? _currentUser;

  ProfileNotifier({
    required ProfileRepository repository,
    UserEntity? currentUser,
  })  : _repository = repository,
        _currentUser = currentUser,
        super(
          ProfileState(
            user: UserProfile(
              id: currentUser?.id ?? 'student_uc_001',
              fullName: (currentUser?.displayName != null && currentUser!.displayName!.trim().isNotEmpty)
                  ? currentUser.displayName!
                  : 'Estudiante UC',
              career: currentUser?.department ?? 'Pregrado UC',
              universityEmail: currentUser?.email ?? 'estudiante@uc.cl',
              avatarUrl: currentUser?.photoUrl ?? 'panda',
              isMindfulActive: true,
            ),
            preferences: const WellnessPreferences(),
            supportContact: const InstitutionalSupportContact(),
          ),
        ) {
    loadProfile();
  }

  /// Carga el estado del perfil desde el repositorio según el usuario actual.
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.getProfileState(
      userId: _currentUser?.id,
      email: _currentUser?.email,
      displayName: _currentUser?.displayName,
      department: _currentUser?.department,
      avatarUrl: _currentUser?.photoUrl,
    );
    result.when(
      onSuccess: (profileState) {
        state = profileState.copyWith(isLoading: false);
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  /// Conmuta el estado de los recordatorios conscientes.
  Future<void> toggleConsciousReminders(bool enabled) async {
    final updatedPrefs = state.preferences.copyWith(
      consciousRemindersEnabled: enabled,
    );
    await updatePreferences(updatedPrefs);
  }

  /// Selecciona el paisaje sonoro predeterminado.
  Future<void> selectAmbientSound(String sound) async {
    final updatedPrefs = state.preferences.copyWith(
      defaultAmbientSound: sound,
    );
    await updatePreferences(updatedPrefs);
  }

  /// Selecciona la técnica de respiración favorita.
  Future<void> selectBreathingTechnique(String technique) async {
    final updatedPrefs = state.preferences.copyWith(
      favoriteBreathingTechnique: technique,
    );
    await updatePreferences(updatedPrefs);
  }

  /// Selecciona la frecuencia de los recordatorios conscientes.
  Future<void> selectReminderInterval(String interval) async {
    final updatedPrefs = state.preferences.copyWith(
      reminderIntervalDescription: interval,
    );
    await updatePreferences(updatedPrefs);
  }

  /// Actualiza las preferencias completas de bienestar para el usuario.
  Future<void> updatePreferences(WellnessPreferences preferences) async {
    state = state.copyWith(preferences: preferences);
    final result = await _repository.updatePreferences(
      preferences,
      userId: _currentUser?.id,
    );
    result.when(
      onSuccess: (_) {},
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
    );
  }

  /// Actualiza los datos de identidad y personales del estudiante.
  Future<bool> updateUserProfile({
    required String fullName,
    required String career,
    required String universityEmail,
    String? avatarUrl,
  }) async {
    final updatedUser = state.user.copyWith(
      fullName: fullName,
      career: career,
      universityEmail: universityEmail,
      avatarUrl: avatarUrl,
    );
    state = state.copyWith(user: updatedUser);

    final result = await _repository.updateUserProfile(
      userId: _currentUser?.id ?? state.user.id,
      fullName: fullName,
      career: career,
      universityEmail: universityEmail,
      avatarUrl: avatarUrl,
    );

    return result.when(
      onSuccess: (_) => true,
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }

  /// Cierra la sesión en este dispositivo.
  Future<bool> logout() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.logout(userId: _currentUser?.id);
    state = state.copyWith(isLoading: false);
    return result.isSuccess;
  }
}
