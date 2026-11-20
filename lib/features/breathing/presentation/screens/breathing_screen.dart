import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import 'package:minduc/features/profile/presentation/controllers/profile_controller.dart';
import '../../domain/entities/breathing_session_state.dart';
import '../controllers/breathing_session_controller.dart';
import '../widgets/breathing_circle_visualizer.dart';
import '../widgets/breathing_controls_row.dart';
import '../widgets/breathing_header.dart';
import '../widgets/breathing_summary_dialog.dart';
import '../widgets/duration_presets_pill.dart';
import '../widgets/session_progress_card.dart';
import '../widgets/technique_selector_row.dart';

/// Pantalla oficial de Sesión de Respiración y Relajación Consciente de mindUC
/// según el diseño de Figma (`mindUC - Respiracion y Relajacion.png`).
class BreathingScreen extends ConsumerWidget {
  const BreathingScreen({super.key});

  void _showCompletionDialog(
    BuildContext context,
    WidgetRef ref,
    BreathingSessionState state,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return BreathingSummaryDialog(
          durationSeconds: state.totalSecondsElapsed,
          cyclesCompleted: state.currentCycle,
          techniqueName: state.technique.name,
          onReturnHome: () {
            Navigator.of(dialogCtx).pop();
            if (context.mounted) {
              if (GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            }
          },
          onRepeat: () {
            Navigator.of(dialogCtx).pop();
            ref.read(breathingSessionControllerProvider.notifier).resetSession();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(breathingSessionControllerProvider);
    final controller = ref.read(breathingSessionControllerProvider.notifier);

    // Escuchar la transición al estado completado para desplegar el modal sereno
    ref.listen<BreathingSessionState>(
      breathingSessionControllerProvider,
      (previous, next) {
        if (next.status == SessionStatus.completed &&
            previous?.status != SessionStatus.completed) {
          _showCompletionDialog(context, ref, next);
        }
      },
    );

    return Scaffold(
      backgroundColor: MindColors.background,
      appBar: BreathingHeader(
        avatarUrl: ref.watch(profileControllerProvider.select((s) => s.user.avatarUrl)),
        onProfile: () => context.go(AppRoutes.profile),
        onBack: () {
          if (GoRouter.of(context).canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.home);
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // 1. Selector desplegable de técnica y contador de ciclos
              TechniqueSelectorRow(
                currentTechnique: sessionState.technique,
                currentCycle: sessionState.currentCycle,
                totalCycles: sessionState.totalCycles,
                onTechniqueChanged: (tech) => controller.setTechnique(tech),
              ),

              const SizedBox(height: 16),

              // 2. Tarjeta con tiempo restante y barra de progreso lineal
              SessionProgressCard(
                elapsedSeconds: sessionState.totalSecondsElapsed,
                targetSeconds: sessionState.targetTotalSeconds,
                progressFraction: sessionState.sessionProgressFraction,
              ),

              const SizedBox(height: 32),

              // 3. Visualizador circular biomecánico animado responsivo
              LayoutBuilder(
                builder: (context, constraints) {
                  final circleSize = constraints.maxWidth < 280
                      ? (constraints.maxWidth * 0.8)
                      : 260.0;
                  return RepaintBoundary(
                    child: BreathingCircleVisualizer(
                      phase: sessionState.phase,
                      secondsRemaining: sessionState.phaseSecondsRemaining,
                      phaseProgressFraction: sessionState.phaseProgressFraction,
                      isRunning: sessionState.isRunning,
                      size: circleSize,
                    ),
                  );
                },
              ),

              const SizedBox(height: 36),

              // 4. Fila de controles: Reinicio, Cápsula Play/Pausa, Stop
              BreathingControlsRow(
                isRunning: sessionState.isRunning,
                onReset: () => controller.resetSession(),
                onPlayPause: () => controller.playOrPause(),
                onStop: () => controller.stopSession(),
              ),

              const SizedBox(height: 16),

              // Control interactivo de Guía Sonora de Respiración
              GestureDetector(
                onTap: () => controller.toggleSound(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sessionState.isSoundEnabled
                        ? MindColors.bienestarPill
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: sessionState.isSoundEnabled
                          ? MindColors.primary
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        sessionState.isSoundEnabled
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        size: 18,
                        color: sessionState.isSoundEnabled
                            ? MindColors.primaryDark
                            : MindColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        sessionState.isSoundEnabled
                            ? 'Guía sonora activada'
                            : 'Guía sonora en silencio',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: sessionState.isSoundEnabled
                              ? MindColors.primaryDark
                              : MindColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 5. Selector segmentado de duración (3 min, 5 min, 10 min, Libre)
              DurationPresetsPill(
                currentTargetSeconds: sessionState.targetTotalSeconds,
                onPresetSelected: (sec) => controller.setTargetDuration(sec),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
