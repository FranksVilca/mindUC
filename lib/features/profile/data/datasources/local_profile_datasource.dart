import '../../domain/entities/institutional_support_contact.dart';
import '../../domain/entities/profile_state.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/wellness_preferences.dart';

/// Fuente de datos local en memoria para el perfil y preferencias del estudiante.
class LocalProfileDataSource {
  static const List<String> availableAmbientSounds = [
    'Lluvia suave en el bosque',
    'Bosque al atardecer',
    'Océano calmo',
    'Viento de montaña',
    'Café acogedor',
  ];

  static const List<String> availableBreathingTechniques = [
    'Caja 4–4–4',
    'Respiración 4–7–8',
    'Respiración Abdominal',
    'Respiración Energizante',
  ];

  ProfileState _state;

  LocalProfileDataSource({ProfileState? initialState})
      : _state = initialState ??
            const ProfileState(
              user: UserProfile(
                id: 'student_uc_001',
                fullName: 'Camila Soto',
                career: 'Psicología',
                universityEmail: 'camila.soto@uc.cl',
                isMindfulActive: true,
              ),
              preferences: WellnessPreferences(
                defaultAmbientSound: 'Lluvia suave en el bosque',
                favoriteBreathingTechnique: 'Caja 4–4–4',
                consciousRemindersEnabled: true,
                reminderIntervalDescription: 'Pausas cada 2 horas de estudio',
              ),
              supportContact: InstitutionalSupportContact(
                title: 'Línea de Apoyo Psicológico',
                description: 'Anexo universitario confidencial',
                phoneNumber: '+56 9 1234 5678',
                extensionNumber: '*4000',
                availability: 'Atención 24/7 confidencial para la comunidad UC',
                isConfidential: true,
              ),
            );

  Future<ProfileState> getProfileState() async {
    return _state;
  }

  Future<void> updatePreferences(WellnessPreferences preferences) async {
    _state = _state.copyWith(preferences: preferences);
  }

  Future<void> logout() async {
    // Simula la invalidación de la sesión local
    _state = _state.copyWith(isLoading: false);
  }
}

