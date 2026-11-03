import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pomodoro_interval_type.dart';
import '../../domain/entities/pomodoro_state.dart';

/// Proveedor global para el controlador reactivo de la sesión Pomodoro.
final pomodoroControllerProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  return PomodoroNotifier();
});

/// Controlador reactivo de la sesión de concentración Pomodoro.
class PomodoroNotifier extends StateNotifier<PomodoroState> {
  PomodoroNotifier([PomodoroState? initialState])
      : super(initialState ?? const PomodoroState());

  Timer? _timer;
  DateTime? _expectedEndTime;

  /// Inicia o reanuda la cuenta regresiva del intervalo activo con precisión diferencial.
  void startTimer() {
    if (state.isRunning) return;

    if (state.remainingSeconds <= 0) {
      state = state.copyWith(remainingSeconds: state.totalSeconds);
    }

    _expectedEndTime = DateTime.now().add(
      Duration(seconds: state.remainingSeconds),
    );

    state = state.copyWith(isRunning: true);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  /// Pausa la cuenta regresiva del intervalo activo.
  void pauseTimer() {
    if (!state.isRunning) return;

    _timer?.cancel();
    _timer = null;

    if (_expectedEndTime != null) {
      final diff = _expectedEndTime!.difference(DateTime.now()).inSeconds;
      final remaining = diff > 0 ? diff : 0;
      state = state.copyWith(isRunning: false, remainingSeconds: remaining);
    } else {
      state = state.copyWith(isRunning: false);
    }
    _expectedEndTime = null;
  }

  /// Alterna entre iniciar y pausar la sesión.
  void toggleTimer() {
    if (state.isRunning) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  /// Reinicia el intervalo activo a su duración inicial completa.
  void resetInterval() {
    pauseTimer();
    state = state.copyWith(
      remainingSeconds: state.totalSeconds,
      isRunning: false,
    );
  }

  /// Salta manualmente al siguiente intervalo de la sesión.
  void skipInterval() {
    pauseTimer();
    _transitionToNextInterval();
  }

  /// Selecciona un tipo de intervalo manualmente (Enfoque, Corto, Largo).
  void selectIntervalType(PomodoroIntervalType type) {
    pauseTimer();
    state = state.copyWith(
      intervalType: type,
      totalSeconds: type.defaultDurationSeconds,
      remainingSeconds: type.defaultDurationSeconds,
      isRunning: false,
    );
  }

  /// Actualiza el objetivo académico visible en la tarjeta.
  void updateObjective(String newObjective) {
    final trimmed = newObjective.trim();
    if (trimmed.isNotEmpty) {
      state = state.copyWith(currentObjective: trimmed);
    }
  }

  /// Selecciona una pista de ambiente sonoro o conmuta su reproducción.
  void toggleSoundscapeTrack(String trackId) {
    if (state.selectedSoundscapeId == trackId) {
      state = state.copyWith(
        isSoundscapePlaying: !state.isSoundscapePlaying,
      );
    } else {
      state = state.copyWith(
        selectedSoundscapeId: trackId,
        isSoundscapePlaying: true,
      );
    }
  }

  /// Modifica el volumen del ambiente sonoro (0.0 a 1.0).
  void setSoundscapeVolume(double volume) {
    state = state.copyWith(
      soundscapeVolume: volume.clamp(0.0, 1.0),
    );
  }

  /// Conmuta el estado del Modo Enfoque Profundo consciente.
  void toggleDeepFocus(bool enabled) {
    state = state.copyWith(isDeepFocusEnabled: enabled);
  }

  void _onTick(Timer timer) {
    if (_expectedEndTime == null) return;

    final diff = _expectedEndTime!.difference(DateTime.now()).inSeconds;
    if (diff <= 0) {
      timer.cancel();
      _timer = null;
      _expectedEndTime = null;
      state = state.copyWith(remainingSeconds: 0, isRunning: false);
      _transitionToNextInterval();
    } else {
      state = state.copyWith(remainingSeconds: diff);
    }
  }

  void _transitionToNextInterval() {
    if (state.intervalType == PomodoroIntervalType.focus) {
      if (state.currentCycle >= state.totalCycles) {
        state = state.copyWith(
          intervalType: PomodoroIntervalType.longBreak,
          totalSeconds: PomodoroIntervalType.longBreak.defaultDurationSeconds,
          remainingSeconds: PomodoroIntervalType.longBreak.defaultDurationSeconds,
          isRunning: false,
        );
      } else {
        state = state.copyWith(
          intervalType: PomodoroIntervalType.shortBreak,
          totalSeconds: PomodoroIntervalType.shortBreak.defaultDurationSeconds,
          remainingSeconds: PomodoroIntervalType.shortBreak.defaultDurationSeconds,
          isRunning: false,
        );
      }
    } else {
      // Veníamos de un descanso
      final nextCycle = state.intervalType == PomodoroIntervalType.longBreak
          ? 1
          : (state.currentCycle < state.totalCycles ? state.currentCycle + 1 : 1);

      state = state.copyWith(
        intervalType: PomodoroIntervalType.focus,
        currentCycle: nextCycle,
        totalSeconds: PomodoroIntervalType.focus.defaultDurationSeconds,
        remainingSeconds: PomodoroIntervalType.focus.defaultDurationSeconds,
        isRunning: false,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}

