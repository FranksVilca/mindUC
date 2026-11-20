import '../../../../core/firebase/firebase_initializer.dart';
import '../../domain/entities/agenda_activity.dart';
import '../../domain/repositories/agenda_repository.dart';
import '../datasources/firestore_agenda_datasource.dart';
import '../datasources/local_agenda_datasource.dart';

/// Implementación del repositorio de agenda bajo Clean Architecture con
/// soporte para Cloud Firestore y fallback automático a almacenamiento local.
class AgendaRepositoryImpl implements AgendaRepository {
  final FirestoreAgendaDataSource _firestoreDataSource;
  final LocalAgendaDataSource _localDataSource;

  AgendaRepositoryImpl({
    FirestoreAgendaDataSource? firestoreDataSource,
    LocalAgendaDataSource? localDataSource,
  })  : _firestoreDataSource =
            firestoreDataSource ?? FirestoreAgendaDataSource(),
        _localDataSource = localDataSource ?? LocalAgendaDataSource();

  bool get _useFirestore => FirebaseInitializer.isInitialized;

  @override
  Future<List<AgendaActivity>> getActivities([String userId = '']) async {
    if (_useFirestore) {
      try {
        final activities = await _firestoreDataSource.getActivities(userId);
        // Mantiene una copia local en caché en un solo pase por lote
        await _localDataSource.saveActivities(activities, userId);
        return activities;
      } catch (_) {
        // En caso de fallo o modo sin conexión, retorna caché local
        return _localDataSource.getActivities(userId);
      }
    }
    return _localDataSource.getActivities(userId);
  }

  @override
  Future<void> saveActivity(AgendaActivity activity) async {
    await _localDataSource.saveActivity(activity);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.saveActivity(activity);
      } catch (_) {
        // Se mantiene en caché local y sincronizará en la próxima reconexión
      }
    }
  }

  @override
  Future<void> toggleActivityCompletion(String id, [String userId = '']) async {
    await _localDataSource.toggleActivityCompletion(id, userId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.toggleActivityCompletion(id, userId);
      } catch (_) {}
    }
  }

  @override
  Future<void> deleteActivity(String id, [String userId = '']) async {
    await _localDataSource.deleteActivity(id, userId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.deleteActivity(id, userId);
      } catch (_) {}
    }
  }
}
