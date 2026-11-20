import '../../domain/entities/agenda_activity.dart';
import '../../domain/repositories/agenda_repository.dart';
import '../datasources/local_agenda_datasource.dart';

/// Implementación concreta del repositorio de agenda utilizando LocalDataSource en memoria.
class LocalAgendaRepositoryImpl implements AgendaRepository {
  LocalAgendaRepositoryImpl({LocalAgendaDataSource? dataSource})
      : _dataSource = dataSource ?? LocalAgendaDataSource();

  final LocalAgendaDataSource _dataSource;

  @override
  Future<List<AgendaActivity>> getActivities([String userId = '']) =>
      _dataSource.getActivities(userId);

  @override
  Future<void> saveActivity(AgendaActivity activity) =>
      _dataSource.saveActivity(activity);

  @override
  Future<void> toggleActivityCompletion(String id, [String userId = '']) =>
      _dataSource.toggleActivityCompletion(id, userId);

  @override
  Future<void> deleteActivity(String id, [String userId = '']) =>
      _dataSource.deleteActivity(id, userId);
}
