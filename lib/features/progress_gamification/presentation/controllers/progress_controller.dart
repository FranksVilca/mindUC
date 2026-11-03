import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/local_progress_repository_impl.dart';
import '../../domain/entities/active_streak.dart';
import '../../domain/entities/organic_achievement.dart';
import '../../domain/entities/progress_summary_state.dart';
import '../../domain/entities/weekly_intention.dart';
import '../../domain/entities/weekly_pause_metrics.dart';
import '../../domain/repositories/progress_repository.dart';

/// Proveedor del repositorio de progreso
final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return LocalProgressRepositoryImpl();
});

/// Proveedor reactivo del controlador de progreso y gamificación compasiva
final progressControllerProvider =
    StateNotifierProvider<ProgressNotifier, ProgressSummaryState>((ref) {
  final repository = ref.watch(progressRepositoryProvider);
  return ProgressNotifier(repository);
});

/// Interfaz del controlador de progreso
abstract class IProgressController {
  Future<void> toggleIntention(String intentionId);
  Future<void> refresh();
}

/// StateNotifier reactivo para la pantalla de Progreso & Florecimiento
class ProgressNotifier extends StateNotifier<ProgressSummaryState>
    implements IProgressController {
  final ProgressRepository _repository;

  ProgressNotifier(this._repository) : super(_defaultInitialState) {
    _load();
  }

  static ProgressSummaryState get _defaultInitialState {
    return const ProgressSummaryState(
      streak: ActiveStreak(
        daysCount: 7,
        message: 'Tu brote de serenidad floreció hoy con tu pausa matutina.',
        completedDays: [true, true, true, true, true, true, true],
        currentDayIndex: 6,
      ),
      metrics: WeeklyPauseMetrics(
        breathingMinutes: 145,
        pomodoroSessions: 12,
        journalEntriesCount: 9,
        balancePercentage: 85,
      ),
      achievements: [
        OrganicAchievement(
          id: 'ach-1',
          title: 'Semilla de Paz',
          description: '1ª semana seguida de respiración guiada',
          category: AchievementCategory.peace,
          isBloomed: true,
          currentProgress: 7.0,
          maxProgress: 7.0,
          progressLabel: 'Florecida',
        ),
        OrganicAchievement(
          id: 'ach-2',
          title: 'Mente Serena',
          description: '10 pausas activas completadas',
          category: AchievementCategory.mind,
          isBloomed: true,
          currentProgress: 10.0,
          maxProgress: 10.0,
          progressLabel: 'Florecida',
        ),
        OrganicAchievement(
          id: 'ach-3',
          title: 'Voz Auténtica',
          description: '5 notas reflexivas en tu diario',
          category: AchievementCategory.voice,
          isBloomed: true,
          currentProgress: 5.0,
          maxProgress: 5.0,
          progressLabel: 'Florecida',
        ),
        OrganicAchievement(
          id: 'ach-4',
          title: 'Foco Lúcido',
          description: '5h en modo concentración plena',
          category: AchievementCategory.focus,
          isBloomed: false,
          currentProgress: 4.0,
          maxProgress: 5.0,
          progressLabel: '4h de 5h (80%)',
        ),
      ],
      intentions: [
        WeeklyIntention(
          id: 'int-1',
          title: 'Hacer 3 pausas activas antes del almuerzo',
          currentUnits: 3,
          targetUnits: 3,
          unitLabel: 'completadas hoy',
          isCompleted: true,
          iconType: IntentionIconType.pauses,
        ),
        WeeklyIntention(
          id: 'int-2',
          title: 'Tomar un paseo consciente de 10 min',
          currentUnits: 2,
          targetUnits: 3,
          unitLabel: 'días',
          isCompleted: false,
          iconType: IntentionIconType.walk,
        ),
        WeeklyIntention(
          id: 'int-3',
          title: 'Desconectar pantallas 30 min antes de dormir',
          currentUnits: 2,
          targetUnits: 4,
          unitLabel: 'noches',
          isCompleted: false,
          iconType: IntentionIconType.screens,
        ),
      ],
    );
  }

  Future<void> _load() async {
    final summary = await _repository.getProgressSummary();
    state = summary;
  }

  @override
  Future<void> toggleIntention(String intentionId) async {
    final updatedSummary =
        await _repository.toggleIntentionProgress(intentionId);
    state = updatedSummary;
  }

  @override
  Future<void> refresh() async {
    final summary = await _repository.getProgressSummary();
    state = summary;
  }
}
