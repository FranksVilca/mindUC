import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/firebase/firebase_initializer.dart';
import '../../domain/entities/profile_state.dart';
import '../../domain/entities/wellness_preferences.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/firestore_profile_datasource.dart';
import '../datasources/local_profile_datasource.dart';

/// Implementación del repositorio de perfil con soporte dual:
/// Cloud Firestore para persistencia en la nube y LocalProfileDataSource como respaldo offline/tests.
class ProfileRepositoryImpl implements ProfileRepository {
  final FirestoreProfileDataSource _firestoreDataSource;
  final LocalProfileDataSource _localDataSource;

  ProfileRepositoryImpl({
    FirestoreProfileDataSource? firestoreDataSource,
    LocalProfileDataSource? localDataSource,
  })  : _firestoreDataSource =
            firestoreDataSource ?? FirestoreProfileDataSource(),
        _localDataSource = localDataSource ?? LocalProfileDataSource();

  bool get _useFirestore => FirebaseInitializer.isInitialized;

  @override
  Future<Result<ProfileState, AppFailure>> getProfileState({
    String? userId,
    String? email,
    String? displayName,
    String? department,
    String? avatarUrl,
  }) async {
    if (_useFirestore) {
      try {
        final state = await _firestoreDataSource.getProfileState(
          userId: userId,
          email: email,
          displayName: displayName,
          department: department,
          avatarUrl: avatarUrl,
        );
        // Sincroniza localmente
        await _localDataSource.updatePreferences(
          state.preferences,
          userId: state.user.id,
        );
        await _localDataSource.updateUserProfile(
          userId: state.user.id,
          fullName: state.user.fullName,
          career: state.user.career,
          universityEmail: state.user.universityEmail,
          avatarUrl: state.user.avatarUrl,
        );
        return Success(state);
      } catch (e) {
        // En caso de fallo o modo sin conexión, utiliza el almacén local
      }
    }

    try {
      final state = await _localDataSource.getProfileState(
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
    await _localDataSource.updatePreferences(preferences, userId: userId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.updatePreferences(preferences, userId: userId);
      } catch (_) {}
    }
    return const Success(null);
  }

  @override
  Future<Result<void, AppFailure>> updateUserProfile({
    required String userId,
    required String fullName,
    required String career,
    required String universityEmail,
    String? avatarUrl,
  }) async {
    await _localDataSource.updateUserProfile(
      userId: userId,
      fullName: fullName,
      career: career,
      universityEmail: universityEmail,
      avatarUrl: avatarUrl,
    );
    if (_useFirestore) {
      try {
        await _firestoreDataSource.updateUserProfile(
          userId: userId,
          fullName: fullName,
          career: career,
          universityEmail: universityEmail,
          avatarUrl: avatarUrl,
        );
      } catch (_) {}
    }
    return const Success(null);
  }

  @override
  Future<Result<void, AppFailure>> logout({String? userId}) async {
    await _localDataSource.logout(userId: userId);
    return const Success(null);
  }
}
