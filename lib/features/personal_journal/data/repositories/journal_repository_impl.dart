import '../../../../core/firebase/firebase_initializer.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/firestore_journal_datasource.dart';
import '../datasources/local_journal_datasource.dart';

/// Implementación del repositorio de diario personal con soporte dual
/// para Cloud Firestore (producción y tiempo real) y LocalDataSource (fallback/tests).
class JournalRepositoryImpl implements JournalRepository {
  final FirestoreJournalDataSource _firestoreDataSource;
  final LocalJournalDataSource _localDataSource;

  JournalRepositoryImpl({
    FirestoreJournalDataSource? firestoreDataSource,
    LocalJournalDataSource? localDataSource,
  })  : _firestoreDataSource =
            firestoreDataSource ?? FirestoreJournalDataSource(),
        _localDataSource = localDataSource ?? LocalJournalDataSource();

  bool get _useFirestore => FirebaseInitializer.isInitialized;

  @override
  Future<List<JournalEntry>> getEntries([String userId = '']) async {
    if (_useFirestore) {
      try {
        final entries = await _firestoreDataSource.getEntries(userId);
        await _localDataSource.saveEntries(entries, userId);
        return entries;
      } catch (_) {
        return _localDataSource.getEntries(userId);
      }
    }
    return _localDataSource.getEntries(userId);
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    await _localDataSource.saveEntry(entry);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.saveEntry(entry);
      } catch (_) {}
    }
  }

  @override
  Future<void> deleteEntry(String id, [String userId = '']) async {
    await _localDataSource.deleteEntry(id, userId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.deleteEntry(id, userId);
      } catch (_) {}
    }
  }
}
