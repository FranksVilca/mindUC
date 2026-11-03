import '../../domain/entities/agenda_activity.dart';
import '../../domain/repositories/agenda_repository.dart';
import '../datasources/local_agenda_datasource.dart';

/// Implementación concreta del repositorio de agenda usando almacenamiento local (Principio V).
class LocalAgendaRepositoryImpl implements AgendaRepository {
  LocalAgendaRepositoryImpl({LocalAgendaDataSource? dataSource})
      : _dataSource = dataSource ?? LocalAgendaDataSource();

  final LocalAgendaDataSource _dataSource;

  @override
  Future<List<AgendaActivity>> getActivities() => _dataSource.getActivities();

  @override
  Future<void> saveActivity(AgendaActivity activity) =>
      _dataSource.saveActivity(activity);

  @override
  Future<void> toggleActivityCompletion(String id) =>
      _dataSource.toggleActivityCompletion(id);

  @override
  Future<void> deleteActivity(String id) => _dataSource.deleteActivity(id);
}

