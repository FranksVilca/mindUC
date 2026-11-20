import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/firebase/firebase_initializer.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/fake_mood_datasource.dart';
import '../datasources/firestore_mood_datasource.dart';
import '../models/mood_model.dart';

/// Implementación del repositorio de estado de ánimo desacoplado con soporte
/// para Cloud Firestore y fallback a FakeMoodDataSource en tests y modo local.
class MoodRepositoryImpl implements MoodRepository {
  final FakeMoodDataSource? _fakeDataSource;
  final FirestoreMoodDataSource _firestoreDataSource;

  MoodRepositoryImpl({
    FakeMoodDataSource? fakeDataSource,
    FirestoreMoodDataSource? firestoreDataSource,
  })  : _fakeDataSource = fakeDataSource,
        _firestoreDataSource =
            firestoreDataSource ?? FirestoreMoodDataSource();

  bool get _isFake => !FirebaseInitializer.isInitialized;

  FakeMoodDataSource get _resolvedFake =>
      _fakeDataSource ?? FakeMoodDataSource();

  @override
  Future<Result<MoodEntry?, AppFailure>> getTodayMood({
    required String userId,
    required String dateString,
  }) async {
    try {
      if (userId.trim().isEmpty) {
        return const FailureResult(
          ValidationFailure('userId cannot be empty', field: 'userId'),
        );
      }

      if (!_isFake) {
        try {
          final entry = await _firestoreDataSource.getTodayMood(
            userId: userId,
            dateString: dateString,
          );
          if (entry != null) {
            await _resolvedFake.saveMood(MoodModel.fromDomain(entry));
            return Success(entry);
          }
        } catch (_) {
          // Fallback a almacenamiento local si Firestore no está disponible
        }
      }

      final model = await _resolvedFake.getMood(userId, dateString);
      return Success(model?.toDomain());
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<MoodEntry, AppFailure>> saveMood({
    required String userId,
    required String dateString,
    required MoodType mood,
  }) async {
    try {
      if (userId.trim().isEmpty) {
        return const FailureResult(
          ValidationFailure('userId cannot be empty', field: 'userId'),
        );
      }

      final localModel = MoodModel(
        id: '${userId}_$dateString',
        userId: userId,
        dateString: dateString,
        mood: mood.name,
        timestampMillis: DateTime.now().millisecondsSinceEpoch,
      );

      // Respaldo local in-memory inmediato
      final savedLocal = await _resolvedFake.saveMood(localModel);

      if (!_isFake) {
        try {
          final entry = await _firestoreDataSource.saveMood(
            userId: userId,
            dateString: dateString,
            mood: mood,
          );
          return Success(entry);
        } catch (_) {
          // En caso de corte de red, el registro local es válido y exitoso
          return Success(savedLocal.toDomain());
        }
      }

      return Success(savedLocal.toDomain());
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MoodEntry>, AppFailure>> getWeeklyMoods({
    required String userId,
  }) async {
    try {
      if (userId.trim().isEmpty) {
        return const FailureResult(
          ValidationFailure('userId cannot be empty', field: 'userId'),
        );
      }

      if (!_isFake) {
        try {
          final entries = await _firestoreDataSource.getWeeklyMoods(userId: userId);
          if (entries.isNotEmpty) {
            return Success(entries);
          }
        } catch (_) {
          // Fallback a almacenamiento local
        }
      }

      final models = await _resolvedFake.getWeeklyMoods(userId);
      return Success(models.map((m) => m.toDomain()).toList());
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
