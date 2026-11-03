import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../breathing/domain/entities/breathing_technique.dart';
import '../../../breathing/presentation/controllers/breathing_session_controller.dart';
import '../../domain/entities/wellness_state.dart';
import '../../domain/entities/wellness_suggested_exercise.dart';

/// Provider reactivo del estado del Hub de Bienestar.
final wellnessControllerProvider =
    StateNotifierProvider<WellnessNotifier, WellnessState>((ref) {
  return WellnessNotifier();
});

/// Controlador del Hub de Bienestar de mindUC.
class WellnessNotifier extends StateNotifier<WellnessState> {
  WellnessNotifier() : super(const WellnessState());

  /// Conmuta el modo santuario sereno.
  void toggleSanctuaryMode() {
    state = state.copyWith(isSanctuaryActive: !state.isSanctuaryActive);
  }

  /// Actualiza el ejercicio sugerido del día.
  void setSuggestedExercise(WellnessSuggestedExercise exercise) {
    state = state.copyWith(suggestedExercise: exercise);
  }

  /// Inicia el ejercicio de respiración sugerido en un solo toque,
  /// precargando la técnica relajante y la duración de 5 min (300s).
  void startSuggestedBreathing(WidgetRef ref, BuildContext context) {
    final breathingNotifier = ref.read(breathingSessionControllerProvider.notifier);
    breathingNotifier.setTechnique(BreathingTechnique.relaxing478);
    breathingNotifier.setTargetDuration(300);
    context.push(AppRoutes.breathingSession);
  }
}
