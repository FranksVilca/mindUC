import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/institutional_support_contact.dart';
import '../../domain/entities/profile_state.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/wellness_preferences.dart';

/// Fuente de datos local para el perfil y preferencias del estudiante.
/// Aísla los perfiles por ID de usuario y persiste los cambios en SharedPreferences.
class LocalProfileDataSource {
  static const List<String> availableAmbientSounds = [
    'Lluvia campus',
    'Cafetería calma',
    'Bosque natural',
    'Bosque al atardecer',
    'Lluvia suave en el bosque',
    'Océano calmo',
    'Café acogedor',
  ];

  static const List<String> availableBreathingTechniques = [
    'Respiración 4-4-4 (Caja)',
    'Respiración 4-7-8 (Relajante)',
    'Respiración Serena 8-7',
    'Caja 4–4–4',
    'Respiración 4–7–8',
    'Respiración Abdominal',
    'Respiración Energizante',
  ];

  static const List<String> availableReminderIntervals = [
    'Pausas cada 45 minutos de estudio',
    'Pausas cada 1 hora de estudio',
    'Pausas cada 90 minutos de estudio',
    'Pausas cada 2 horas de estudio',
  ];

  static final Map<String, ProfileState> _userProfiles = {};
  final SharedPreferences? _preferences;

  LocalProfileDataSource({
    ProfileState? initialState,
    SharedPreferences? preferences,
  }) : _preferences = preferences {
    if (initialState != null) {
      _userProfiles[initialState.user.id] = initialState;
    }
  }

  static void clearProfiles() {
    _userProfiles.clear();
  }

  SharedPreferences? _cachedPrefs;

  Future<SharedPreferences?> _getPrefs() async {
    if (_preferences != null) return _preferences;
    if (_cachedPrefs != null) return _cachedPrefs;
    try {
      _cachedPrefs = await SharedPreferences.getInstance();
      return _cachedPrefs;
    } catch (_) {
      return null;
    }
  }

  String _storageKey(String userId) => 'profile_state_${userId.trim().isEmpty ? 'guest' : userId.trim()}';

  static ProfileState _createDefaultProfile({
    String? userId,
    String? email,
    String? displayName,
    String? department,
    String? avatarUrl,
  }) {
    final effectiveId = (userId != null && userId.trim().isNotEmpty)
        ? userId
        : 'student_uc_001';
    final effectiveEmail = (email != null && email.trim().isNotEmpty)
        ? email
        : 'estudiante@uc.cl';
    final effectiveName = (displayName != null && displayName.trim().isNotEmpty)
        ? displayName
        : 'Estudiante UC';
    final effectiveCareer = (department != null && department.trim().isNotEmpty)
        ? department
        : 'Pregrado UC';

    return ProfileState(
      user: UserProfile(
        id: effectiveId,
        fullName: effectiveName,
        career: effectiveCareer,
        universityEmail: effectiveEmail,
        avatarUrl: avatarUrl ?? 'panda',
        isMindfulActive: true,
      ),
      preferences: const WellnessPreferences(
        defaultAmbientSound: 'Lluvia suave en el bosque',
        favoriteBreathingTechnique: 'Caja 4–4–4',
        consciousRemindersEnabled: true,
        reminderIntervalDescription: 'Pausas cada 2 horas de estudio',
      ),
      supportContact: const InstitutionalSupportContact(
        title: 'Línea de Apoyo Psicológico',
        description: 'Anexo universitario confidencial',
        phoneNumber: '+56 9 1234 5678',
        extensionNumber: '*4000',
        availability: 'Atención 24/7 confidencial para la comunidad UC',
        isConfidential: true,
      ),
    );
  }

  Future<void> _persistForUser(String key, ProfileState state) async {
    try {
      final prefs = await _getPrefs();
      if (prefs == null) return;
      final map = {
        'user': state.user.toJson(),
        'preferences': state.preferences.toJson(),
      };
      await prefs.setString(_storageKey(key), jsonEncode(map));
    } catch (_) {
      // Ignorar fallos de persistencia en entornos de test sin plataforma
    }
  }

  Future<ProfileState> getProfileState({
    String? userId,
    String? email,
    String? displayName,
    String? department,
    String? avatarUrl,
  }) async {
    final key = userId ?? email ?? 'student_uc_001';
    if (_userProfiles.containsKey(key)) {
      return _userProfiles[key]!;
    }

    try {
      final prefs = await _getPrefs();
      if (_userProfiles.containsKey(key)) {
        return _userProfiles[key]!;
      }
      final raw = prefs?.getString(_storageKey(key));
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final user = UserProfile.fromJson(
            Map<String, dynamic>.from(decoded['user'] as Map));
        final preferences = WellnessPreferences.fromJson(
            Map<String, dynamic>.from(decoded['preferences'] as Map));

        final loaded = ProfileState(
          user: user.avatarUrl == null || user.avatarUrl!.isEmpty
              ? user.copyWith(avatarUrl: avatarUrl ?? 'panda')
              : user,
          preferences: preferences,
          supportContact: const InstitutionalSupportContact(),
        );
        _userProfiles[key] = loaded;
        return loaded;
      }
    } catch (_) {
      // Fallback a nuevo perfil si no hay nada guardado
    }

    if (_userProfiles.containsKey(key)) {
      return _userProfiles[key]!;
    }

    final newProfile = _createDefaultProfile(
      userId: userId,
      email: email,
      displayName: displayName,
      department: department,
      avatarUrl: avatarUrl,
    );
    _userProfiles[key] = newProfile;
    return newProfile;
  }

  Future<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String career,
    required String universityEmail,
    String? avatarUrl,
  }) async {
    final key = userId.trim().isEmpty ? 'student_uc_001' : userId.trim();
    final current = _userProfiles[key] ?? _createDefaultProfile(userId: userId);
    final updatedUser = current.user.copyWith(
      fullName: fullName,
      career: career,
      universityEmail: universityEmail,
      avatarUrl: avatarUrl ?? current.user.avatarUrl,
    );
    final updatedState = current.copyWith(user: updatedUser);
    _userProfiles[key] = updatedState;
    await _persistForUser(key, updatedState);
  }

  Future<void> updatePreferences(
    WellnessPreferences preferences, {
    String? userId,
  }) async {
    final key = userId ?? 'student_uc_001';
    final current = _userProfiles[key] ?? _createDefaultProfile(userId: userId);
    final updatedState = current.copyWith(preferences: preferences);
    _userProfiles[key] = updatedState;
    await _persistForUser(key, updatedState);
  }

  Future<void> logout({String? userId}) async {
    // Sesión cerrada
  }
}
