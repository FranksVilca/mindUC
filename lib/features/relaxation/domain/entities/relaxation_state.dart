import 'relaxation_activity.dart';
import 'relaxation_step.dart';

/// Estado inmutable reactivo del módulo de Relajación y Pausas Activas.
class RelaxationState {
  final List<RelaxationActivity> activities;
  final RelaxationActivity? activeActivity;
  final int currentStepIndex;
  final int stepRemainingSeconds;
  final int totalElapsedSeconds;
  final bool isPlaying;
  final bool isSessionCompleted;

  const RelaxationState({
    this.activities = RelaxationActivity.defaultActivities,
    this.activeActivity,
    this.currentStepIndex = 0,
    this.stepRemainingSeconds = 0,
    this.totalElapsedSeconds = 0,
    this.isPlaying = false,
    this.isSessionCompleted = false,
  });

  /// Paso activo actual de la rutina en curso.
  RelaxationStep? get currentStep {
    if (activeActivity == null ||
        currentStepIndex < 0 ||
        currentStepIndex >= activeActivity!.steps.length) {
      return null;
    }
    return activeActivity!.steps[currentStepIndex];
  }

  /// Progreso de la cuenta regresiva del paso actual (de 0.0 a 1.0).
  double get currentStepProgress {
    final step = currentStep;
    if (step == null || step.durationSeconds <= 0) return 0.0;
    final elapsed = step.durationSeconds - stepRemainingSeconds;
    return (elapsed / step.durationSeconds).clamp(0.0, 1.0);
  }

  /// Progreso global de la actividad (número de pasos completados / total de pasos).
  double get overallActivityProgress {
    if (activeActivity == null || activeActivity!.steps.isEmpty) return 0.0;
    return ((currentStepIndex + (1.0 - (stepRemainingSeconds / (currentStep?.durationSeconds ?? 1)))) /
            activeActivity!.steps.length)
        .clamp(0.0, 1.0);
  }

  /// Cantidad de pausas y ejercicios completados hoy por el usuario.
  int get completedActivitiesCountToday {
    return activities.where((a) => a.isCompletedToday).length;
  }

  /// Minutos acumulados de alivio y relajación corporal hoy.
  int get totalReliefMinutesToday {
    int totalSecs = 0;
    for (final a in activities) {
      if (a.isCompletedToday) {
        totalSecs += a.totalDurationSeconds * a.completionsCount;
      }
    }
    return (totalSecs / 60).round();
  }

  RelaxationState copyWith({
    List<RelaxationActivity>? activities,
    RelaxationActivity? activeActivity,
    bool clearActiveActivity = false,
    int? currentStepIndex,
    int? stepRemainingSeconds,
    int? totalElapsedSeconds,
    bool? isPlaying,
    bool? isSessionCompleted,
  }) {
    return RelaxationState(
      activities: activities ?? this.activities,
      activeActivity:
          clearActiveActivity ? null : (activeActivity ?? this.activeActivity),
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      stepRemainingSeconds: stepRemainingSeconds ?? this.stepRemainingSeconds,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
      isPlaying: isPlaying ?? this.isPlaying,
      isSessionCompleted: isSessionCompleted ?? this.isSessionCompleted,
    );
  }
}
