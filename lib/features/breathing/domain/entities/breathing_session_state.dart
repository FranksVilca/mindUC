import 'breathing_phase.dart';
import 'breathing_technique.dart';

enum SessionStatus { idle, running, paused, completed }

/// Modelo inmutable del estado reactivo de la sesión de respiración.
class BreathingSessionState {
  final BreathingTechnique technique;
  final BreathingPhase phase;
  final int phaseSecondsRemaining;
  final int totalSecondsElapsed;
  final int targetTotalSeconds; // 0 indica Modo Libre
  final int currentCycle;
  final int totalCycles;
  final SessionStatus status;
  final bool isSoundEnabled;

  const BreathingSessionState({
    required this.technique,
    this.phase = BreathingPhase.inhale,
    required this.phaseSecondsRemaining,
    this.totalSecondsElapsed = 0,
    this.targetTotalSeconds = 600, // 10 min por defecto
    this.currentCycle = 1,
    required this.totalCycles,
    this.status = SessionStatus.idle,
    this.isSoundEnabled = true,
  });

  bool get isFreeMode => targetTotalSeconds <= 0;
  bool get isRunning => status == SessionStatus.running;
  bool get isPaused => status == SessionStatus.paused;
  bool get isCompleted => status == SessionStatus.completed;

  int get phaseTotalSeconds {
    switch (phase) {
      case BreathingPhase.inhale:
        return technique.inhaleSeconds;
      case BreathingPhase.hold:
        return technique.holdSeconds;
      case BreathingPhase.exhale:
        return technique.exhaleSeconds;
      case BreathingPhase.rest:
        return technique.postHoldSeconds;
    }
  }

  double get phaseProgressFraction {
    final total = phaseTotalSeconds;
    if (total <= 0) return 1.0;
    return (1.0 - (phaseSecondsRemaining / total)).clamp(0.0, 1.0);
  }

  double get sessionProgressFraction {
    if (isFreeMode || targetTotalSeconds <= 0) return 0.0;
    return (totalSecondsElapsed / targetTotalSeconds).clamp(0.0, 1.0);
  }

  BreathingSessionState copyWith({
    BreathingTechnique? technique,
    BreathingPhase? phase,
    int? phaseSecondsRemaining,
    int? totalSecondsElapsed,
    int? targetTotalSeconds,
    int? currentCycle,
    int? totalCycles,
    SessionStatus? status,
    bool? isSoundEnabled,
  }) {
    return BreathingSessionState(
      technique: technique ?? this.technique,
      phase: phase ?? this.phase,
      phaseSecondsRemaining: phaseSecondsRemaining ?? this.phaseSecondsRemaining,
      totalSecondsElapsed: totalSecondsElapsed ?? this.totalSecondsElapsed,
      targetTotalSeconds: targetTotalSeconds ?? this.targetTotalSeconds,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      status: status ?? this.status,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
    );
  }
}
