import '../../domain/entities/active_streak.dart';
import '../../domain/entities/organic_achievement.dart';
import '../../domain/entities/progress_summary_state.dart';
import '../../domain/entities/weekly_intention.dart';
import '../../domain/entities/weekly_pause_metrics.dart';

/// Fuente de datos local en el dispositivo para el progreso y gamificación compasiva.
/// Almacena métricas, intenciones y logros aislados estrictamente por ID de usuario.
class LocalProgressDataSource {
  static final Map<String, ProgressSummaryState> _userStates = {};

  LocalProgressDataSource({ProgressSummaryState? initialState, String defaultUserId = ''}) {
    if (initialState != null) {
      _userStates[defaultUserId] = initialState;
    }
  }

  static void clearStates() {
    _userStates.clear();
  }

  /// Estado inicial completamente limpio y en ceros para cualquier usuario nuevo.
  /// No incluye logros, intenciones ni métricas precargadas de prueba.
  static ProgressSummaryState get initialEmptyState {
    return const ProgressSummaryState(
      streak: ActiveStreak(
        daysCount: 0,
        message: 'Inicia hoy tu camino de bienestar y pausas conscientes.',
        completedDays: [false, false, false, false, false, false, false],
        currentDayIndex: 0,
      ),
      metrics: WeeklyPauseMetrics(
        breathingMinutes: 0,
        pomodoroSessions: 0,
        journalEntriesCount: 0,
        balancePercentage: 0,
      ),
      achievements: [],
      intentions: [],
      quote:
          '“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”',
      quoteSubtitle: 'Recordatorio de autocompasión',
    );
  }

  /// Estado con datos de ejemplo para tests de diseño específicos con usuarios existentes.
  static ProgressSummaryState get mockInitialState {
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

  /// Retorna el resumen consolidado de progreso del usuario autenticado.
  /// Cada usuario nuevo inicia completamente limpio en ceros.
  Future<ProgressSummaryState> getProgressSummary([String userId = '']) async {
    return _userStates.putIfAbsent(userId, () => initialEmptyState);
  }

  /// Conmuta o incrementa el avance de una intención semanal para el usuario.
  Future<ProgressSummaryState> toggleIntentionProgress(
    String intentionId, [
    String userId = '',
  ]) async {
    final current = _userStates.putIfAbsent(userId, () => initialEmptyState);

    final updatedIntentions = current.intentions.map((intention) {
      if (intention.id != intentionId) return intention;

      if (intention.isCompleted) {
        final newUnits = intention.targetUnits > 1 ? intention.targetUnits - 1 : 0;
        return intention.copyWith(
          currentUnits: newUnits,
          isCompleted: false,
        );
      } else {
        final newUnits = intention.currentUnits + 1;
        final completed = newUnits >= intention.targetUnits;
        return intention.copyWith(
          currentUnits: newUnits.clamp(0, intention.targetUnits),
          isCompleted: completed,
        );
      }
    }).toList();

    final updated = current.copyWith(intentions: updatedIntentions);
    _userStates[userId] = updated;
    return updated;
  }

  /// Incrementa una sesión de Pomodoro completada y actualiza el logro correspondiente.
  Future<void> incrementPomodoroSession([String userId = '']) async {
    final current = _userStates.putIfAbsent(userId, () => initialEmptyState);
    final newSessions = current.metrics.pomodoroSessions + 1;
    final updatedMetrics = current.metrics.copyWith(
      pomodoroSessions: newSessions,
      balancePercentage: ((newSessions * 10) + current.metrics.breathingMinutes).clamp(0, 100),
    );

    final updatedAchievements = List<OrganicAchievement>.from(current.achievements);
    final focusIndex = updatedAchievements.indexWhere((a) => a.id == 'ach-4');
    final focusProgress = (newSessions * 0.5).clamp(0.0, 5.0);
    final isBloomed = focusProgress >= 5.0;
    final achievement = OrganicAchievement(
      id: 'ach-4',
      title: 'Foco Lúcido',
      description: '5h en modo concentración plena',
      category: AchievementCategory.focus,
      isBloomed: isBloomed,
      currentProgress: focusProgress,
      maxProgress: 5.0,
      progressLabel: isBloomed ? 'Florecida' : '${focusProgress.toStringAsFixed(1)}h de 5h',
    );

    if (focusIndex >= 0) {
      updatedAchievements[focusIndex] = achievement;
    } else {
      updatedAchievements.add(achievement);
    }

    _userStates[userId] = current.copyWith(
      metrics: updatedMetrics,
      achievements: updatedAchievements,
    );
  }

  /// Registra minutos de respiración guiada para el usuario y actualiza logros.
  Future<void> recordBreathingMinutes(int minutes, [String userId = '']) async {
    final current = _userStates.putIfAbsent(userId, () => initialEmptyState);
    final newMinutes = current.metrics.breathingMinutes + minutes;
    final updatedMetrics = current.metrics.copyWith(
      breathingMinutes: newMinutes,
      balancePercentage: ((current.metrics.pomodoroSessions * 10) + newMinutes).clamp(0, 100),
    );

    final updatedAchievements = List<OrganicAchievement>.from(current.achievements);
    final peaceIndex = updatedAchievements.indexWhere((a) => a.id == 'ach-1');
    final peaceProgress = (newMinutes / 10).clamp(0.0, 7.0);
    final isBloomed = peaceProgress >= 7.0;
    final achievement = OrganicAchievement(
      id: 'ach-1',
      title: 'Semilla de Paz',
      description: '1ª semana seguida de respiración guiada',
      category: AchievementCategory.peace,
      isBloomed: isBloomed,
      currentProgress: peaceProgress,
      maxProgress: 7.0,
      progressLabel: isBloomed ? 'Florecida' : '${peaceProgress.toInt()} de 7 días',
    );

    if (peaceIndex >= 0) {
      updatedAchievements[peaceIndex] = achievement;
    } else {
      updatedAchievements.add(achievement);
    }

    _userStates[userId] = current.copyWith(
      metrics: updatedMetrics,
      achievements: updatedAchievements,
    );
  }

  /// Actualiza el conteo de notas del diario personal para el usuario y actualiza logros.
  Future<void> updateJournalEntriesCount(int count, [String userId = '']) async {
    final current = _userStates.putIfAbsent(userId, () => initialEmptyState);
    final updatedMetrics = current.metrics.copyWith(
      journalEntriesCount: count,
    );

    final updatedAchievements = List<OrganicAchievement>.from(current.achievements);
    final voiceIndex = updatedAchievements.indexWhere((a) => a.id == 'ach-3');
    final voiceProgress = count.toDouble().clamp(0.0, 5.0);
    final isBloomed = voiceProgress >= 5.0;
    final achievement = OrganicAchievement(
      id: 'ach-3',
      title: 'Voz Auténtica',
      description: '5 notas reflexivas en tu diario',
      category: AchievementCategory.voice,
      isBloomed: isBloomed,
      currentProgress: voiceProgress,
      maxProgress: 5.0,
      progressLabel: isBloomed ? 'Florecida' : '$count de 5 notas',
    );

    if (voiceIndex >= 0) {
      updatedAchievements[voiceIndex] = achievement;
    } else {
      updatedAchievements.add(achievement);
    }

    _userStates[userId] = current.copyWith(
      metrics: updatedMetrics,
      achievements: updatedAchievements,
    );
  }
}
