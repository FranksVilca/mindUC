import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../profile/domain/entities/profile_state.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../progress_gamification/domain/repositories/progress_repository.dart';
import '../../../progress_gamification/presentation/controllers/progress_controller.dart';
import '../../domain/entities/pomodoro_interval_type.dart';
import '../../domain/entities/pomodoro_state.dart';
import '../../domain/services/soundscape_audio_service.dart';

/// Mapea el nombre de preferencia sonora al id de pista de Pomodoro
String soundNameToTrackId(String soundName) {
  final lower = soundName.toLowerCase();
  if (lower.contains('lluvia') || lower.contains('rain')) return 'rain';
  if (lower.contains('caf') || lower.contains('coffee')) return 'cafe';
  if (lower.contains('bosque') ||
      lower.contains('forest') ||
      lower.contains('viento') ||
      lower.contains('árbol')) {
    return 'forest';
  }
  return 'rain';
}

/// Proveedor global para el servicio de audio ambiental de mindUC.
final soundscapeAudioServiceProvider = Provider<SoundscapeAudioService>((ref) {
  final service = SoundscapeAudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Proveedor global para el controlador reactivo de la sesión Pomodoro.
final pomodoroControllerProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  final audioService = ref.watch(soundscapeAudioServiceProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  final profileState = ref.watch(profileControllerProvider);

  final preferredTrackId =
      soundNameToTrackId(profileState.preferences.defaultAmbientSound);

  final notifier = PomodoroNotifier(
    audioService: audioService,
    progressRepository: progressRepo,
    authRepository: authRepo,
    preferredSoundscapeId: preferredTrackId,
  );

  ref.listen<ProfileState>(profileControllerProvider, (previous, next) {
    if (previous?.preferences.defaultAmbientSound !=
        next.preferences.defaultAmbientSound) {
      notifier.applyPreferredSoundscape(next.preferences.defaultAmbientSound);
    }
  });

  return notifier;
});

/// Controlador reactivo de la sesión de concentración Pomodoro.
class PomodoroNotifier extends StateNotifier<PomodoroState> {
  PomodoroNotifier({
    SoundscapeAudioService? audioService,
    ProgressRepository? progressRepository,
    AuthRepository? authRepository,
    String? preferredSoundscapeId,
    PomodoroState? initialState,
  })  : _audioService = audioService,
        _progressRepository = progressRepository,
        _authRepository = authRepository,
        super(
          (initialState ?? const PomodoroState()).copyWith(
            selectedSoundscapeId: preferredSoundscapeId ??
                (initialState?.selectedSoundscapeId ?? 'rain'),
          ),
        );

  final SoundscapeAudioService? _audioService;
  final ProgressRepository? _progressRepository;
  final AuthRepository? _authRepository;
  Timer? _timer;
  DateTime? _expectedEndTime;

  /// Aplica el paisaje sonoro favorito establecido en el perfil
  void applyPreferredSoundscape(String soundName) {
    if (state.isSoundscapePlaying) return;
    final trackId = soundNameToTrackId(soundName);
    if (state.selectedSoundscapeId != trackId) {
      state = state.copyWith(selectedSoundscapeId: trackId);
    }
  }

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
      final shouldPlay = !state.isSoundscapePlaying;
      state = state.copyWith(isSoundscapePlaying: shouldPlay);
      if (shouldPlay) {
        _audioService?.playTrack(trackId, volume: state.soundscapeVolume);
      } else {
        _audioService?.pause();
      }
    } else {
      state = state.copyWith(
        selectedSoundscapeId: trackId,
        isSoundscapePlaying: true,
      );
      _audioService?.playTrack(trackId, volume: state.soundscapeVolume);
    }
  }

  /// Inicia o reanuda la reproducción del sonido ambiental activo.
  void playSoundscape() {
    final trackId = state.selectedSoundscapeId ?? 'rain';
    state = state.copyWith(
      selectedSoundscapeId: trackId,
      isSoundscapePlaying: true,
    );
    _audioService?.playTrack(trackId, volume: state.soundscapeVolume);
  }

  /// Pausa el sonido ambiental activo.
  void pauseSoundscape() {
    _audioService?.pause();
    if (mounted && state.isSoundscapePlaying) {
      state = state.copyWith(isSoundscapePlaying: false);
    }
  }

  /// Detiene el sonido ambiental y lo restablece.
  void stopSoundscape() {
    _audioService?.stop();
    if (mounted && state.isSoundscapePlaying) {
      state = state.copyWith(isSoundscapePlaying: false);
    }
  }

  /// Modifica el volumen del ambiente sonoro (0.0 a 1.0).
  void setSoundscapeVolume(double volume) {
    final clamped = volume.clamp(0.0, 1.0);
    state = state.copyWith(soundscapeVolume: clamped);
    _audioService?.setVolume(clamped);
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
      final userId = _authRepository?.currentUser?.id ?? '';
      unawaited(_progressRepository?.incrementPomodoroSession(userId));
      unawaited(NotificationService.instance.showPomodoroBreakNotification());

      if (state.currentCycle < state.totalCycles) {
        state = state.copyWith(
          intervalType: PomodoroIntervalType.shortBreak,
          totalSeconds: PomodoroIntervalType.shortBreak.defaultDurationSeconds,
          remainingSeconds:
              PomodoroIntervalType.shortBreak.defaultDurationSeconds,
          isRunning: false,
        );
      } else {
        state = state.copyWith(
          intervalType: PomodoroIntervalType.longBreak,
          totalSeconds: PomodoroIntervalType.longBreak.defaultDurationSeconds,
          remainingSeconds:
              PomodoroIntervalType.longBreak.defaultDurationSeconds,
          isRunning: false,
        );
      }
    } else if (state.intervalType == PomodoroIntervalType.shortBreak) {
      unawaited(NotificationService.instance.showPomodoroFocusNotification());
      state = state.copyWith(
        currentCycle: state.currentCycle + 1,
        intervalType: PomodoroIntervalType.focus,
        totalSeconds: PomodoroIntervalType.focus.defaultDurationSeconds,
        remainingSeconds: PomodoroIntervalType.focus.defaultDurationSeconds,
        isRunning: false,
      );
    } else {
      // Fin del ciclo Pomodoro completo (4 ciclos completados)
      unawaited(NotificationService.instance.showPomodoroFocusNotification());
      state = state.copyWith(
        currentCycle: 1,
        intervalType: PomodoroIntervalType.focus,
        totalSeconds: PomodoroIntervalType.focus.defaultDurationSeconds,
        remainingSeconds: PomodoroIntervalType.focus.defaultDurationSeconds,
        isRunning: false,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
