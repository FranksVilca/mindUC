import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/institutional_support_contact.dart';
import '../../domain/entities/profile_state.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/wellness_preferences.dart';

/// Fuente de datos de Cloud Firestore para el perfil del estudiante y sus preferencias.
/// Almacena y sincroniza la información en la colección `users/{userId}`.
class FirestoreProfileDataSource {
  final FirebaseService _firebaseService;

  FirestoreProfileDataSource({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String userId) =>
      _firebaseService.userDoc(userId);

  /// Carga el perfil completo del estudiante desde Cloud Firestore
  Future<ProfileState> getProfileState({
    String? userId,
    String? email,
    String? displayName,
    String? department,
    String? avatarUrl,
  }) async {
    final effectiveId = (userId != null && userId.trim().isNotEmpty)
        ? userId.trim()
        : _firebaseService.currentUserId;

    final docRef = _userDoc(effectiveId);
    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data() != null) {
      final data = snapshot.data()!;
      final userMap = data['userProfile'] as Map<String, dynamic>? ?? data;
      final prefMap = data['wellnessPreferences'] as Map<String, dynamic>?;

      final userProfile = UserProfile(
        id: effectiveId,
        fullName: userMap['fullName'] as String? ??
            userMap['displayName'] as String? ??
            displayName ??
            'Estudiante UC',
        career: userMap['career'] as String? ??
            userMap['department'] as String? ??
            department ??
            'Pregrado UC',
        universityEmail: userMap['universityEmail'] as String? ??
            userMap['email'] as String? ??
            email ??
            'estudiante@uc.cl',
        avatarUrl: userMap['avatarUrl'] as String? ??
            userMap['photoUrl'] as String? ??
            avatarUrl ??
            'panda',
        isMindfulActive: userMap['isMindfulActive'] as bool? ?? true,
      );

      final preferences = prefMap != null
          ? WellnessPreferences.fromJson(prefMap)
          : const WellnessPreferences();

      return ProfileState(
        user: userProfile,
        preferences: preferences,
        supportContact: const InstitutionalSupportContact(),
      );
    }

    // Si el documento aún no existe en Firestore, lo crea con los datos actuales
    final initialProfile = UserProfile(
      id: effectiveId,
      fullName: (displayName != null && displayName.trim().isNotEmpty)
          ? displayName.trim()
          : 'Estudiante UC',
      career: (department != null && department.trim().isNotEmpty)
          ? department.trim()
          : 'Pregrado UC',
      universityEmail: (email != null && email.trim().isNotEmpty)
          ? email.trim()
          : 'estudiante@uc.cl',
      avatarUrl: avatarUrl ?? 'panda',
      isMindfulActive: true,
    );

    const initialPrefs = WellnessPreferences();

    final state = ProfileState(
      user: initialProfile,
      preferences: initialPrefs,
      supportContact: const InstitutionalSupportContact(),
    );

    await docRef.set({
      'userProfile': {
        'id': initialProfile.id,
        'fullName': initialProfile.fullName,
        'career': initialProfile.career,
        'universityEmail': initialProfile.universityEmail,
        'avatarUrl': initialProfile.avatarUrl,
        'isMindfulActive': initialProfile.isMindfulActive,
      },
      'displayName': initialProfile.fullName,
      'department': initialProfile.career,
      'email': initialProfile.universityEmail,
      'photoUrl': initialProfile.avatarUrl,
      'wellnessPreferences': initialPrefs.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return state;
  }

  /// Actualiza las preferencias en Cloud Firestore
  Future<void> updatePreferences(
    WellnessPreferences preferences, {
    String? userId,
  }) async {
    final effectiveId = (userId != null && userId.trim().isNotEmpty)
        ? userId.trim()
        : _firebaseService.currentUserId;

    await _userDoc(effectiveId).set({
      'wellnessPreferences': preferences.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Actualiza los datos de identidad del estudiante en Cloud Firestore
  Future<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String career,
    required String universityEmail,
    String? avatarUrl,
  }) async {
    final effectiveId =
        userId.trim().isNotEmpty ? userId.trim() : _firebaseService.currentUserId;

    await _userDoc(effectiveId).set({
      'userProfile': {
        'id': effectiveId,
        'fullName': fullName.trim(),
        'career': career.trim(),
        'universityEmail': universityEmail.trim(),
        'avatarUrl': avatarUrl,
        'isMindfulActive': true,
      },
      'displayName': fullName.trim(),
      'department': career.trim(),
      'email': universityEmail.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
