import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../progress_gamification/domain/repositories/progress_repository.dart';
import '../../../progress_gamification/presentation/controllers/progress_controller.dart';
import '../../data/repositories/journal_repository_impl.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_mood_pulse.dart';
import '../../domain/entities/journal_state.dart';
import '../../domain/repositories/journal_repository.dart';

/// Proveedor del repositorio de diario personal con soporte Cloud Firestore.
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepositoryImpl();
});

/// Proveedor global para el controlador reactivo del diario personal aislado por usuario.
final journalControllerProvider =
    StateNotifierProvider<JournalNotifier, JournalState>((ref) {
  final repository = ref.watch(journalRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);
  final userId = currentUser?.id ?? '';
  return JournalNotifier(
    repository: repository,
    userId: userId,
    progressRepository: progressRepo,
  );
});

/// Controlador reactivo del Diario Personal íntimo bajo el Principio V.
class JournalNotifier extends StateNotifier<JournalState> {
  JournalNotifier({
    required JournalRepository repository,
    this.userId = '',
    ProgressRepository? progressRepository,
  })  : _repository = repository,
        _progressRepository = progressRepository,
        super(const JournalState()) {
    loadEntries();
  }

  final JournalRepository _repository;
  final String userId;
  final ProgressRepository? _progressRepository;

  /// Carga las huellas interiores del usuario autenticado.
  Future<void> loadEntries() async {
    state = state.copyWith(isLoading: true);
    final entries = await _repository.getEntries(userId);
    state = state.copyWith(entries: entries, isLoading: false);
    if (userId.isNotEmpty) {
      await _progressRepository?.updateJournalEntriesCount(entries.length, userId);
    }
  }

  /// Selecciona el pulso emocional activo para sintonizar el sentir.
  void selectMoodPulse(JournalMoodPulse pulse) {
    state = state.copyWith(selectedMoodPulse: pulse);
  }

  /// Crea y persiste una nueva reflexión en el dispositivo asociada al usuario.
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
      userId: userId,
      title: trimmedTitle,
      content: trimmedContent,
      moodPulse: moodPulse ?? state.selectedMoodPulse,
      createdAt: DateTime.now(),
    );

    await _repository.saveEntry(entry);
    await loadEntries();
  }

  /// Modifica una reflexión existente del usuario en el dispositivo.
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

  /// Elimina definitivamente una reflexión del dispositivo del usuario.
  Future<void> deleteEntry(String id) async {
    await _repository.deleteEntry(id, userId);
    await loadEntries();
  }
}
