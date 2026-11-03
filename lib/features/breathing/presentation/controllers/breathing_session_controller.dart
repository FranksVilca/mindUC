import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/datasources/fake_breathing_datasource.dart';
import '../../data/repositories/breathing_repository_impl.dart';
import '../../domain/entities/breathing_phase.dart';
import '../../domain/entities/breathing_session_log.dart';
import '../../domain/entities/breathing_session_state.dart';
import '../../domain/entities/breathing_technique.dart';
import '../../domain/repositories/breathing_repository.dart';

/// Provider del repositorio de respiración consciente.
final breathingRepositoryProvider = Provider<BreathingRepository>((ref) {
  return BreathingRepositoryImpl(fakeDataSource: FakeBreathingDataSource());
});

/// Provider del controlador reactivo de la sesión de respiración.
final breathingSessionControllerProvider =
    StateNotifierProvider<BreathingSessionNotifier, BreathingSessionState>((ref) {
  final repo = ref.watch(breathingRepositoryProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return BreathingSessionNotifier(
    breathingRepository: repo,
    authRepository: authRepo,
  );
});

/// Controlador con máquina de estados finitos y temporizador reactivo
/// para la sesión de respiración consciente guiada.
class BreathingSessionNotifier extends StateNotifier<BreathingSessionState> {
  final BreathingRepository _breathingRepository;
  final AuthRepository? _authRepository;
  Timer? _timer;

  BreathingSessionNotifier({
    required BreathingRepository breathingRepository,
    AuthRepository? authRepository,
  })  : _breathingRepository = breathingRepository,
        _authRepository = authRepository,
        super(
          BreathingSessionState(
            technique: BreathingTechnique.box444,
            phase: BreathingPhase.inhale,
            phaseSecondsRemaining: BreathingTechnique.box444.inhaleSeconds,
            totalSecondsElapsed: 0,
            targetTotalSeconds: 600, // 10 min por defecto según Figma
            currentCycle: 1,
            totalCycles: (600 / BreathingTechnique.box444.cycleDurationSeconds).ceil(),
            status: SessionStatus.idle,
          ),
        );

  /// Inicia o conmuta entre pausa y reproducción.
  void playOrPause() {
    if (state.status == SessionStatus.running) {
      _stopTimer();
      state = state.copyWith(status: SessionStatus.paused);
    } else {
      state = state.copyWith(status: SessionStatus.running);
      _startTimer();
    }
  }

  /// Reinicia la sesión al inicio del ciclo 1.
  void resetSession() {
    _stopTimer();
    state = state.copyWith(
      phase: BreathingPhase.inhale,
      phaseSecondsRemaining: state.technique.inhaleSeconds,
      totalSecondsElapsed: 0,
      currentCycle: 1,
      status: SessionStatus.idle,
    );
  }

  /// Detiene y finaliza la sesión activa, persistiendo los datos si hubo duración.
  Future<void> stopSession() async {
    _stopTimer();
    await _saveSessionLog();
    state = state.copyWith(status: SessionStatus.completed);
  }

  /// Cambia la técnica activa recalculando los ciclos y reiniciando fases si está en espera.
  void setTechnique(BreathingTechnique technique) {
    final int newTotalCycles = state.targetTotalSeconds > 0
        ? (state.targetTotalSeconds / technique.cycleDurationSeconds).ceil()
        : 0;

    if (state.status == SessionStatus.idle || state.status == SessionStatus.completed) {
      state = state.copyWith(
        technique: technique,
        totalCycles: newTotalCycles,
        phase: BreathingPhase.inhale,
        phaseSecondsRemaining: technique.inhaleSeconds,
      );
    } else {
      state = state.copyWith(
        technique: technique,
        totalCycles: newTotalCycles,
      );
    }
  }

  /// Cambia la duración objetivo (en segundos: 180, 300, 600 o 0 para Libre).
  void setTargetDuration(int targetSeconds) {
    final int newTotalCycles = targetSeconds > 0
        ? (targetSeconds / state.technique.cycleDurationSeconds).ceil()
        : 0;

    state = state.copyWith(
      targetTotalSeconds: targetSeconds,
      totalCycles: newTotalCycles,
    );

    // Si ya superó el tiempo objetivo tras cambiar de preset
    if (targetSeconds > 0 && state.totalSecondsElapsed >= targetSeconds) {
      _completeSession();
    }
  }

  /// Avanza 1 segundo en la sesión activa. Expuesto públicamente para pruebas deterministas.
  void tick() {
    if (state.status != SessionStatus.running) return;

    final newTotalElapsed = state.totalSecondsElapsed + 1;

    // Verificar si se alcanzó la meta de tiempo (si no es Modo Libre)
    if (!state.isFreeMode && newTotalElapsed >= state.targetTotalSeconds) {
      state = state.copyWith(
        totalSecondsElapsed: newTotalElapsed,
        phaseSecondsRemaining: 0,
      );
      _completeSession();
      return;
    }

    final newRemaining = state.phaseSecondsRemaining - 1;

    if (newRemaining > 0) {
      state = state.copyWith(
        totalSecondsElapsed: newTotalElapsed,
        phaseSecondsRemaining: newRemaining,
      );
    } else {
      // Transición a la siguiente fase biomecánica
      _transitionToNextPhase(newTotalElapsed);
    }
  }

  void _transitionToNextPhase(int currentElapsed) {
    BreathingPhase nextPhase;
    int nextPhaseSeconds;
    int nextCycle = state.currentCycle;

    switch (state.phase) {
      case BreathingPhase.inhale:
        if (state.technique.holdSeconds > 0) {
          nextPhase = BreathingPhase.hold;
          nextPhaseSeconds = state.technique.holdSeconds;
        } else {
          nextPhase = BreathingPhase.exhale;
          nextPhaseSeconds = state.technique.exhaleSeconds;
        }
        break;

      case BreathingPhase.hold:
        nextPhase = BreathingPhase.exhale;
        nextPhaseSeconds = state.technique.exhaleSeconds;
        break;

      case BreathingPhase.exhale:
        if (state.technique.postHoldSeconds > 0) {
          nextPhase = BreathingPhase.rest;
          nextPhaseSeconds = state.technique.postHoldSeconds;
        } else {
          nextPhase = BreathingPhase.inhale;
          nextPhaseSeconds = state.technique.inhaleSeconds;
          nextCycle += 1;
        }
        break;

      case BreathingPhase.rest:
        nextPhase = BreathingPhase.inhale;
        nextPhaseSeconds = state.technique.inhaleSeconds;
        nextCycle += 1;
        break;
    }

    state = state.copyWith(
      totalSecondsElapsed: currentElapsed,
      phase: nextPhase,
      phaseSecondsRemaining: nextPhaseSeconds,
      currentCycle: nextCycle,
    );
  }

  void _completeSession() {
    _stopTimer();
    state = state.copyWith(status: SessionStatus.completed);
    _saveSessionLog();
  }

  Future<void> _saveSessionLog() async {
    if (state.totalSecondsElapsed <= 0) return;

    final user = _authRepository?.currentUser;
    final userId = user?.id ?? 'anonymous_user';
    final now = DateTime.now();

    final log = BreathingSessionLog(
      id: 'session_${now.millisecondsSinceEpoch}',
      userId: userId,
      techniqueId: state.technique.id,
      durationSeconds: state.totalSecondsElapsed,
      cyclesCompleted: state.currentCycle,
      dateString: SpanishDateFormatter.toIsoDateString(now),
      timestampMillis: now.millisecondsSinceEpoch,
    );

    await _breathingRepository.saveSession(log);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
