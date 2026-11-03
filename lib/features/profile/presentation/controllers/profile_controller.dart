import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_profile_datasource.dart';
import '../../data/repositories/local_profile_repository_impl.dart';
import '../../domain/entities/institutional_support_contact.dart';
import '../../domain/entities/profile_state.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/wellness_preferences.dart';
import '../../domain/repositories/profile_repository.dart';

/// Proveedor del repositorio de perfil.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return LocalProfileRepositoryImpl(
    dataSource: LocalProfileDataSource(),
  );
});

/// Proveedor del controlador de perfil.
final profileControllerProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository: repository);
});

/// Controlador reactivo del perfil y preferencias conscientes del estudiante.
class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileNotifier({required ProfileRepository repository})
      : _repository = repository,
        super(
          const ProfileState(
            user: UserProfile(
              id: 'student_uc_001',
              fullName: 'Camila Soto',
              career: 'Psicología',
              universityEmail: 'camila.soto@uc.cl',
              isMindfulActive: true,
            ),
            preferences: WellnessPreferences(),
            supportContact: InstitutionalSupportContact(),
          ),
        ) {
    loadProfile();
  }

  /// Carga el estado del perfil desde el repositorio.
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.getProfileState();
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

  /// Actualiza las preferencias completas de bienestar.
  Future<void> updatePreferences(WellnessPreferences preferences) async {
    state = state.copyWith(preferences: preferences);
    final result = await _repository.updatePreferences(preferences);
    result.when(
      onSuccess: (_) {},
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
    );
  }

  /// Cierra la sesión en este dispositivo.
  Future<bool> logout() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.logout();
    state = state.copyWith(isLoading: false);
    return result.isSuccess;
  }
}

