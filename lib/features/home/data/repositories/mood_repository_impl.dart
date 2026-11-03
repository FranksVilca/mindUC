import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/fake_mood_datasource.dart';
import '../models/mood_model.dart';

/// Implementación del repositorio de estado de ánimo desacoplado con soporte
/// para Firestore offline y FakeMoodDataSource en tests.
class MoodRepositoryImpl implements MoodRepository {
  final FakeMoodDataSource? _fakeDataSource;
  final FirebaseFirestore? _firestore;

  MoodRepositoryImpl({
    FakeMoodDataSource? fakeDataSource,
    FirebaseFirestore? firestore,
  })  : _fakeDataSource = fakeDataSource,
        _firestore = firestore;

  bool get _isFake => _fakeDataSource != null;

  @override
  Future<Result<MoodEntry?, AppFailure>> getTodayMood({
    required String userId,
    required String dateString,
  }) async {
    try {
      if (userId.trim().isEmpty) {
        return const FailureResult(ValidationFailure('userId cannot be empty', field: 'userId'));
      }

      if (_isFake) {
        final model = await _fakeDataSource!.getMood(userId, dateString);
        return Success(model?.toDomain());
      }

      final doc = await _firestore!
          .collection('users')
          .doc(userId)
          .collection('mood_entries')
          .doc(dateString)
          .get();

      if (!doc.exists || doc.data() == null) {
        return const Success(null);
      }

      final model = MoodModel.fromMap(doc.data()!);
      return Success(model.toDomain());
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
        return const FailureResult(ValidationFailure('userId cannot be empty', field: 'userId'));
      }

      final model = MoodModel(
        id: '${userId}_$dateString',
        userId: userId,
        dateString: dateString,
        mood: mood.name,
        timestampMillis: DateTime.now().millisecondsSinceEpoch,
      );

      if (_isFake) {
        final saved = await _fakeDataSource!.saveMood(model);
        return Success(saved.toDomain());
      }

      await _firestore!
          .collection('users')
          .doc(userId)
          .collection('mood_entries')
          .doc(dateString)
          .set(model.toMap(), SetOptions(merge: true));

      return Success(model.toDomain());
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<MoodEntry>, AppFailure>> getWeeklyMoods({
    required String userId,
  }) async {
    try {
      if (_isFake) {
        final models = await _fakeDataSource!.getWeeklyMoods(userId);
        return Success(models.map((m) => m.toDomain()).toList());
      }

      final snapshot = await _firestore!
          .collection('users')
          .doc(userId)
          .collection('mood_entries')
          .orderBy('timestampMillis', descending: true)
          .limit(7)
          .get();

      final entries = snapshot.docs.map((doc) => MoodModel.fromMap(doc.data()).toDomain()).toList();
      return Success(entries);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
