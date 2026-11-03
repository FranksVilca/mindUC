import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/local_journal_datasource.dart';

/// Implementación concreta del repositorio de diario respaldado en almacenamiento local.
/// Garantiza estricta adhesión al Principio V (cero transmisiones a servidores externos).
class LocalJournalRepositoryImpl implements JournalRepository {
  LocalJournalRepositoryImpl({LocalJournalDataSource? dataSource})
      : _dataSource = dataSource ?? LocalJournalDataSource();

  final LocalJournalDataSource _dataSource;

  @override
  Future<List<JournalEntry>> getEntries() => _dataSource.getEntries();

  @override
  Future<void> saveEntry(JournalEntry entry) => _dataSource.saveEntry(entry);

  @override
  Future<void> deleteEntry(String id) => _dataSource.deleteEntry(id);
}

