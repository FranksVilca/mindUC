import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/firebase/firebase_initializer.dart';
import '../../domain/entities/breathing_session_log.dart';
import '../../domain/repositories/breathing_repository.dart';
import '../datasources/fake_breathing_datasource.dart';
import '../models/breathing_session_model.dart';

/// Implementación del repositorio de respiración con soporte para Firestore y tests.
class BreathingRepositoryImpl implements BreathingRepository {
  final FakeBreathingDataSource _fakeDataSource;
  final FirebaseFirestore? _firestore;

  BreathingRepositoryImpl({
    FakeBreathingDataSource? fakeDataSource,
    FirebaseFirestore? firestore,
  })  : _fakeDataSource = fakeDataSource ?? FakeBreathingDataSource(),
        _firestore = firestore ??
            (FirebaseInitializer.isInitialized
                ? FirebaseFirestore.instance
                : null);

  bool get _hasFirestore => _firestore != null;

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

      // Respaldo local in-memory
      final savedLocal = await _fakeDataSource.saveSession(model);

      if (_hasFirestore) {
        try {
          await _firestore!
              .collection('users')
              .doc(log.userId)
              .collection('breathing_sessions')
              .doc(log.id)
              .set(model.toMap());
        } catch (_) {
          // Si hay corte de red, el registro local garantiza persistencia
        }
      }

      return Success(savedLocal.toDomain());
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

      if (_hasFirestore) {
        try {
          final snapshot = await _firestore!
              .collection('users')
              .doc(userId)
              .collection('breathing_sessions')
              .orderBy('timestampMillis', descending: true)
              .limit(20)
              .get();

          if (snapshot.docs.isNotEmpty) {
            final logs = snapshot.docs
                .map((doc) =>
                    BreathingSessionModel.fromMap(doc.data()).toDomain())
                .toList();
            return Success(logs);
          }
        } catch (_) {
          // Fallback a almacenamiento local
        }
      }

      final models = await _fakeDataSource.getUserSessions(userId);
      return Success(models.map((m) => m.toDomain()).toList());
    } catch (e) {
      return FailureResult(ServerFailure(e.toString()));
    }
  }
}
