import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/local_journal_repository_impl.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_mood_pulse.dart';
import '../../domain/entities/journal_state.dart';
import '../../domain/repositories/journal_repository.dart';

/// Proveedor del repositorio local de diario personal.
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return LocalJournalRepositoryImpl();
});

/// Proveedor global para el controlador reactivo del diario personal.
final journalControllerProvider =
    StateNotifierProvider<JournalNotifier, JournalState>((ref) {
  final repository = ref.watch(journalRepositoryProvider);
  return JournalNotifier(repository: repository);
});

/// Controlador reactivo del Diario Personal íntimo bajo el Principio V.
class JournalNotifier extends StateNotifier<JournalState> {
  JournalNotifier({required JournalRepository repository})
      : _repository = repository,
        super(const JournalState()) {
    loadEntries();
  }

  final JournalRepository _repository;

  /// Carga las huellas interiores del almacenamiento local seguro.
  Future<void> loadEntries() async {
    state = state.copyWith(isLoading: true);
    final entries = await _repository.getEntries();
    state = state.copyWith(entries: entries, isLoading: false);
  }

  /// Selecciona el pulso emocional activo para sintonizar el sentir.
  void selectMoodPulse(JournalMoodPulse pulse) {
    state = state.copyWith(selectedMoodPulse: pulse);
  }

  /// Crea y persiste una nueva reflexión en el dispositivo.
  Future<void> createEntry({
    required String title,
    required String content,
    JournalMoodPulse? moodPulse,
  }) async {
    final trimmedTitle = title.trim();
    final trimmedContent = content.trim();

    if (trimmedTitle.isEmpty || trimmedContent.isEmpty) return;

    final entry = JournalEntry(
      id: 'entry-${DateTime.now().millisecondsSinceEpoch}',
      title: trimmedTitle,
      content: trimmedContent,
      moodPulse: moodPulse ?? state.selectedMoodPulse,
      createdAt: DateTime.now(),
    );

    await _repository.saveEntry(entry);
    await loadEntries();
  }

  /// Modifica una reflexión existente en el dispositivo.
  Future<void> updateEntry({
    required String id,
    required String title,
    required String content,
    required JournalMoodPulse moodPulse,
  }) async {
    final trimmedTitle = title.trim();
    final trimmedContent = content.trim();

    if (trimmedTitle.isEmpty || trimmedContent.isEmpty) return;

    final existingIndex = state.entries.indexWhere((e) => e.id == id);
    if (existingIndex < 0) return;

    final existing = state.entries[existingIndex];
    final updated = existing.copyWith(
      title: trimmedTitle,
      content: trimmedContent,
      moodPulse: moodPulse,
      updatedAt: DateTime.now(),
    );

    await _repository.saveEntry(updated);
    await loadEntries();
  }

  /// Elimina definitivamente una reflexión del dispositivo.
  Future<void> deleteEntry(String id) async {
    await _repository.deleteEntry(id);
    await loadEntries();
  }
}

