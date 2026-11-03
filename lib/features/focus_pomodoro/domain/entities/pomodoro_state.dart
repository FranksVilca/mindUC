import 'pomodoro_interval_type.dart';

/// Estado inmutable de la sesión de concentración Pomodoro.
class PomodoroState {
  const PomodoroState({
    this.sessionTitle = 'Sesión de la tarde',
    this.currentCycle = 2,
    this.totalCycles = 4,
    this.intervalType = PomodoroIntervalType.focus,
    this.remainingSeconds = 1121, // 18 min 41 seg según mockup
    this.totalSeconds = 1500, // 25 min base
    this.isRunning = false,
    this.currentObjective = 'Lectura Cap. 4 — Psicología Social',
    this.selectedSoundscapeId = 'rain',
    this.isSoundscapePlaying = true,
    this.soundscapeVolume = 0.7,
    this.isDeepFocusEnabled = true,
  });

  final String sessionTitle;
  final int currentCycle;
  final int totalCycles;
  final PomodoroIntervalType intervalType;
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final String currentObjective;
  final String? selectedSoundscapeId;
  final bool isSoundscapePlaying;
  final double soundscapeVolume;
  final bool isDeepFocusEnabled;

  /// Progreso normalizado del tiempo transcurrido (0.0 a 1.0) para el arco circular.
  double get progress {
    if (totalSeconds <= 0) return 0.0;
    final elapsed = totalSeconds - remainingSeconds;
    return (elapsed / totalSeconds).clamp(0.0, 1.0);
  }

  /// Tiempo restante formateado en minutos y segundos (MM:SS).
  String get formattedRemainingTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Tiempo total formateado (ej. "de 25:00 min").
  String get formattedTotalTime {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return 'de ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} min';
  }

  /// Indica si el intervalo ha concluido.
  bool get isCompleted => remainingSeconds <= 0;

  PomodoroState copyWith({
    String? sessionTitle,
    int? currentCycle,
    int? totalCycles,
    PomodoroIntervalType? intervalType,
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    String? currentObjective,
    String? selectedSoundscapeId,
    bool? isSoundscapePlaying,
    double? soundscapeVolume,
    bool? isDeepFocusEnabled,
  }) {
    return PomodoroState(
      sessionTitle: sessionTitle ?? this.sessionTitle,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      intervalType: intervalType ?? this.intervalType,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      currentObjective: currentObjective ?? this.currentObjective,
      selectedSoundscapeId: selectedSoundscapeId ?? this.selectedSoundscapeId,
      isSoundscapePlaying: isSoundscapePlaying ?? this.isSoundscapePlaying,
      soundscapeVolume: soundscapeVolume ?? this.soundscapeVolume,
      isDeepFocusEnabled: isDeepFocusEnabled ?? this.isDeepFocusEnabled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroState &&
          runtimeType == other.runtimeType &&
          sessionTitle == other.sessionTitle &&
          currentCycle == other.currentCycle &&
          totalCycles == other.totalCycles &&
          intervalType == other.intervalType &&
          remainingSeconds == other.remainingSeconds &&
          totalSeconds == other.totalSeconds &&
          isRunning == other.isRunning &&
          currentObjective == other.currentObjective &&
          selectedSoundscapeId == other.selectedSoundscapeId &&
          isSoundscapePlaying == other.isSoundscapePlaying &&
          soundscapeVolume == other.soundscapeVolume &&
          isDeepFocusEnabled == other.isDeepFocusEnabled;

  @override
  int get hashCode => Object.hash(
        sessionTitle,
        currentCycle,
        totalCycles,
        intervalType,
        remainingSeconds,
        totalSeconds,
        isRunning,
        currentObjective,
        selectedSoundscapeId,
        isSoundscapePlaying,
        soundscapeVolume,
        isDeepFocusEnabled,
      );
}

