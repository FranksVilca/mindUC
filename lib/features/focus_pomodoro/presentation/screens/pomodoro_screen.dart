import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/soundscape_track.dart';
import '../controllers/pomodoro_controller.dart';
import '../widgets/deep_focus_card.dart';
import '../widgets/interval_selector_row.dart';
import '../widgets/objective_edit_dialog.dart';
import '../widgets/pomodoro_cycle_progress.dart';
import '../widgets/pomodoro_header.dart';
import '../widgets/pomodoro_timer_card.dart';
import '../widgets/soundscape_section.dart';

/// Pantalla principal de la sesión de Concentración Pomodoro de mindUC.
class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pomodoroControllerProvider);
    final notifier = ref.read(pomodoroControllerProvider.notifier);

    return Scaffold(
      backgroundColor: MindColors.background,
      body: SafeArea(
        child: Column(
          children: [
            PomodoroHeader(
              onBack: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Progreso de ciclos de la sesión
                    PomodoroCycleProgress(
                      sessionTitle: state.sessionTitle,
                      currentCycle: state.currentCycle,
                      totalCycles: state.totalCycles,
                    ),
                    const SizedBox(height: 16),

                    // Selector segmentado de intervalo (Enfoque, Corto, Largo)
                    IntervalSelectorRow(
                      selectedType: state.intervalType,
                      onTypeSelected: notifier.selectIntervalType,
                    ),
                    const SizedBox(height: 16),

                    // Tarjeta principal con cronómetro y controles
                    PomodoroTimerCard(
                      state: state,
                      onToggleTimer: notifier.toggleTimer,
                      onResetInterval: notifier.resetInterval,
                      onSkipInterval: notifier.skipInterval,
                      onEditObjective: () {
                        ObjectiveEditDialog.show(
                          context,
                          initialObjective: state.currentObjective,
                          onSave: notifier.updateObjective,
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Sección de ambiente sonoro y volumen
                    SoundscapeSection(
                      tracks: SoundscapeTrack.defaultTracks,
                      selectedTrackId: state.selectedSoundscapeId,
                      isPlaying: state.isSoundscapePlaying,
                      volume: state.soundscapeVolume,
                      onTrackTapped: notifier.toggleSoundscapeTrack,
                      onVolumeChanged: notifier.setSoundscapeVolume,
                    ),
                    const SizedBox(height: 24),

                    // Modo enfoque profundo consciente
                    DeepFocusCard(
                      isEnabled: state.isDeepFocusEnabled,
                      onToggle: notifier.toggleDeepFocus,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

