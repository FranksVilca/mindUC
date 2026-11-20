import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/local_journal_datasource.dart';

/// Implementación del repositorio de Diario Personal que delega en el LocalDataSource.
class LocalJournalRepositoryImpl implements JournalRepository {
  LocalJournalRepositoryImpl({LocalJournalDataSource? dataSource})
      : _dataSource = dataSource ?? LocalJournalDataSource();

  final LocalJournalDataSource _dataSource;

  @override
  Future<List<JournalEntry>> getEntries([String userId = '']) =>
      _dataSource.getEntries(userId);

  @override
  Future<void> saveEntry(JournalEntry entry) => _dataSource.saveEntry(entry);

  @override
  Future<void> deleteEntry(String id, [String userId = '']) =>
      _dataSource.deleteEntry(id, userId);
}
