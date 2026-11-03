import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/breathing_session_log.dart';
import '../../domain/repositories/breathing_repository.dart';
import '../datasources/fake_breathing_datasource.dart';
import '../models/breathing_session_model.dart';

/// Implementación del repositorio de respiración con soporte para Firestore y tests.
class BreathingRepositoryImpl implements BreathingRepository {
  final FakeBreathingDataSource? _fakeDataSource;
  final FirebaseFirestore? _firestore;

  BreathingRepositoryImpl({
    FakeBreathingDataSource? fakeDataSource,
    FirebaseFirestore? firestore,
  })  : _fakeDataSource = fakeDataSource,
        _firestore = firestore;

  bool get _isFake => _fakeDataSource != null;

  @override
  Future<Result<BreathingSessionLog, AppFailure>> saveSession(
    BreathingSessionLog log,
  ) async {
    try {
      if (log.userId.trim().isEmpty) {
        return const FailureResult(
          ValidationFailure('userId cannot be empty', field: 'userId'),
        );
      }

      final model = BreathingSessionModel.fromDomain(log);

      if (_isFake) {
        final saved = await _fakeDataSource!.saveSession(model);
        return Success(saved.toDomain());
      }

      await _firestore!
          .collection('users')
          .doc(log.userId)
          .collection('breathing_sessions')
          .doc(log.id)
          .set(model.toMap());

      return Success(log);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<BreathingSessionLog>, AppFailure>> getUserSessions(
    String userId,
  ) async {
    try {
      if (userId.trim().isEmpty) {
        return const FailureResult(
          ValidationFailure('userId cannot be empty', field: 'userId'),
        );
      }

      if (_isFake) {
        final models = await _fakeDataSource!.getUserSessions(userId);
        return Success(models.map((m) => m.toDomain()).toList());
      }

      final snapshot = await _firestore!
          .collection('users')
          .doc(userId)
          .collection('breathing_sessions')
          .orderBy('timestampMillis', descending: true)
          .limit(20)
          .get();

      final logs = snapshot.docs
          .map((doc) => BreathingSessionModel.fromMap(doc.data()).toDomain())
          .toList();

      return Success(logs);
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
