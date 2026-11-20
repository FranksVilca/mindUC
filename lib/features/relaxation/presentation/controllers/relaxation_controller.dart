import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/relaxation_repository_impl.dart';
import '../../domain/entities/relaxation_state.dart';
import '../../domain/repositories/relaxation_repository.dart';

/// Proveedor del repositorio de relajación.
final relaxationRepositoryProvider = Provider<RelaxationRepository>((ref) {
  return RelaxationRepositoryImpl();
});

/// Proveedor global del controlador interactivo de Relajación y Pausas Activas.
final relaxationControllerProvider =
    StateNotifierProvider<RelaxationNotifier, RelaxationState>((ref) {
  final repo = ref.watch(relaxationRepositoryProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  return RelaxationNotifier(
    repository: repo,
    authRepository: authRepo,
  );
});

/// Controlador reactivo que acompaña al usuario en toda la experiencia de relajación.
class RelaxationNotifier extends StateNotifier<RelaxationState> {
  final RelaxationRepository _repository;
  final AuthRepository _authRepository;
  Timer? _timer;

  RelaxationNotifier({
    required RelaxationRepository repository,
    required AuthRepository authRepository,
    RelaxationState? initialState,
  })  : _repository = repository,
        _authRepository = authRepository,
        super(initialState ?? const RelaxationState()) {
    loadActivities();
  }

  String _getCurrentUserId() {
    return _authRepository.currentUser?.id ?? 'guest_user';
  }

  /// Carga la lista de actividades con el progreso guardado del usuario activo.
  Future<void> loadActivities() async {
    final userId = _getCurrentUserId();
    final activities = await _repository.getActivities(userId: userId);
    if (mounted) {
      state = state.copyWith(activities: activities);
    }
  }

  /// Inicia una rutina guiada por ID de actividad (cuello, espalda, mandíbula, visual).
  void startActivity(String activityId) {
    _timer?.cancel();

    final activity = state.activities.firstWhere(
      (a) => a.id == activityId,
      orElse: () => state.activities.first,
    );

    final firstStep = activity.steps.isNotEmpty ? activity.steps.first : null;
    final initialRemaining = firstStep?.durationSeconds ?? 0;

    state = state.copyWith(
      activeActivity: activity,
      currentStepIndex: 0,
      stepRemainingSeconds: initialRemaining,
      totalElapsedSeconds: 0,
      isPlaying: true,
      isSessionCompleted: false,
    );

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer timer) {
    if (!mounted || !state.isPlaying || state.activeActivity == null) return;

    if (state.stepRemainingSeconds > 1) {
      state = state.copyWith(
        stepRemainingSeconds: state.stepRemainingSeconds - 1,
        totalElapsedSeconds: state.totalElapsedSeconds + 1,
      );
    } else {
      // Avanzar automáticamente al siguiente paso o finalizar
      _advanceStepOrFinish();
    }
  }

  void _advanceStepOrFinish() {
    final activity = state.activeActivity;
    if (activity == null) return;

    final nextIndex = state.currentStepIndex + 1;
    if (nextIndex < activity.steps.length) {
      final nextStep = activity.steps[nextIndex];
      state = state.copyWith(
        currentStepIndex: nextIndex,
        stepRemainingSeconds: nextStep.durationSeconds,
        totalElapsedSeconds: state.totalElapsedSeconds + 1,
      );
    } else {
      _finishRoutine();
    }
  }

  /// Conmuta entre reproducción y pausa del cronómetro del ejercicio.
  void togglePlayPause() {
    if (state.isPlaying) {
      pauseTimer();
    } else {
      resumeTimer();
    }
  }

  /// Pausa el ejercicio guiado.
  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(isPlaying: false);
  }

  /// Reanuda el ejercicio guiado.
  void resumeTimer() {
    if (state.activeActivity != null && !state.isSessionCompleted) {
      state = state.copyWith(isPlaying: true);
      _startTimer();
    }
  }

  /// Salta manual e inmediatamente al siguiente paso.
  void nextStep() {
    final activity = state.activeActivity;
    if (activity == null) return;

    final nextIndex = state.currentStepIndex + 1;
    if (nextIndex < activity.steps.length) {
      final nextStep = activity.steps[nextIndex];
      state = state.copyWith(
        currentStepIndex: nextIndex,
        stepRemainingSeconds: nextStep.durationSeconds,
      );
    } else {
      _finishRoutine();
    }
  }

  /// Retrocede al paso anterior o reinicia el actual.
  void previousStep() {
    final activity = state.activeActivity;
    if (activity == null) return;

    if (state.currentStepIndex > 0) {
      final prevIndex = state.currentStepIndex - 1;
      final prevStep = activity.steps[prevIndex];
      state = state.copyWith(
        currentStepIndex: prevIndex,
        stepRemainingSeconds: prevStep.durationSeconds,
      );
    } else {
      resetStep();
    }
  }

  /// Reinicia el cronómetro del paso actual.
  void resetStep() {
    final step = state.currentStep;
    if (step != null) {
      state = state.copyWith(stepRemainingSeconds: step.durationSeconds);
    }
  }

  /// Culmina la rutina actual, persiste el logro y marca el estado completado.
  Future<void> _finishRoutine() async {
    _timer?.cancel();
    final activity = state.activeActivity;
    if (activity == null) return;

    final userId = _getCurrentUserId();
    await _repository.saveActivityCompletion(
      userId: userId,
      activityId: activity.id,
    );

    final updatedActivities = await _repository.getActivities(userId: userId);

    if (mounted) {
      state = state.copyWith(
        isPlaying: false,
        isSessionCompleted: true,
        activities: updatedActivities,
      );
    }
  }

  /// Finaliza la sesión por decisión del usuario.
  void exitSession() {
    _timer?.cancel();
    state = state.copyWith(
      clearActiveActivity: true,
      isPlaying: false,
      isSessionCompleted: false,
      currentStepIndex: 0,
      stepRemainingSeconds: 0,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
