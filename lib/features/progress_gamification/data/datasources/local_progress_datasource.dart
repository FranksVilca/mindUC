import '../../domain/entities/active_streak.dart';
import '../../domain/entities/organic_achievement.dart';
import '../../domain/entities/progress_summary_state.dart';
import '../../domain/entities/weekly_intention.dart';
import '../../domain/entities/weekly_pause_metrics.dart';

/// Fuente de datos local en el dispositivo para el progreso y gamificación compasiva.
/// Almacena métricas e intenciones en memoria bajo arquitectura Offline-First.
class LocalProgressDataSource {
  LocalProgressDataSource({ProgressSummaryState? initialState}) {
    _state = initialState ?? _initialMockState;
  }

  late ProgressSummaryState _state;

  static ProgressSummaryState get _initialMockState {
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
      quote:
          '“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”',
      quoteSubtitle: 'Recordatorio de autocompasión',
    );
  }

  /// Retorna el resumen consolidado de progreso
  Future<ProgressSummaryState> getProgressSummary() async {
    return _state;
  }

  /// Conmuta o incrementa el avance de una intención semanal
  Future<ProgressSummaryState> toggleIntentionProgress(
      String intentionId) async {
    final updatedIntentions = _state.intentions.map((intention) {
      if (intention.id != intentionId) return intention;

      if (intention.isCompleted) {
        // Al tocar una intención completada, vuelve al estado previo
        final newUnits = intention.targetUnits > 1
            ? intention.targetUnits - 1
            : 0;
        return intention.copyWith(
          currentUnits: newUnits,
          isCompleted: false,
        );
      } else {
        // Incrementar unidades
        final newUnits = intention.currentUnits + 1;
        final completed = newUnits >= intention.targetUnits;
        return intention.copyWith(
          currentUnits: newUnits.clamp(0, intention.targetUnits),
          isCompleted: completed,
        );
      }
    }).toList();

    _state = _state.copyWith(intentions: updatedIntentions);
    return _state;
  }
}
