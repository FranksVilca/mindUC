import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/mind_colors.dart';
import '../controllers/relaxation_controller.dart';
import '../widgets/exercise_controls_bar.dart';
import '../widgets/exercise_header.dart';
import '../widgets/relaxation_body_visualizer.dart';
import '../widgets/relaxation_summary_dialog.dart';

/// Pantalla interactiva que guía al usuario paso a paso en su pausa activa de relajación.
class GuidedExerciseScreen extends ConsumerWidget {
  const GuidedExerciseScreen({super.key});

  void _showCompletionDialog(
    BuildContext context,
    WidgetRef ref,
    String activityName,
    int totalDuration,
    int stepsCount,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return RelaxationSummaryDialog(
          activityName: activityName,
          totalSeconds: totalDuration,
          stepsCount: stepsCount,
          onReturn: () {
            Navigator.of(dialogCtx).pop();
            ref.read(relaxationControllerProvider.notifier).exitSession();
            if (context.mounted && context.canPop()) {
              context.pop();
            }
          },
          onRepeat: () {
            Navigator.of(dialogCtx).pop();
            final currentAct =
                ref.read(relaxationControllerProvider).activeActivity;
            if (currentAct != null) {
              ref
                  .read(relaxationControllerProvider.notifier)
                  .startActivity(currentAct.id);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(relaxationControllerProvider);
    final notifier = ref.read(relaxationControllerProvider.notifier);
    final activity = state.activeActivity;
    final step = state.currentStep;

    // Escuchar el evento de sesión completada
    ref.listen(relaxationControllerProvider, (prev, next) {
      if (next.isSessionCompleted && !(prev?.isSessionCompleted ?? false)) {
        if (next.activeActivity != null) {
          _showCompletionDialog(
            context,
            ref,
            next.activeActivity!.name,
            next.activeActivity!.totalDurationSeconds,
            next.activeActivity!.steps.length,
          );
        }
      }
    });

    if (activity == null || step == null) {
      return Scaffold(
        backgroundColor: MindColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: MindColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('No hay ningún ejercicio activo seleccionado.'),
        ),
      );
    }

    final totalSteps = activity.steps.length;
    final currentStepNumber = state.currentStepIndex + 1;
    final isLastStep = state.currentStepIndex == totalSteps - 1;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        notifier.exitSession();
      },
      child: Scaffold(
        backgroundColor: MindColors.background,
        appBar: ExerciseHeader(
          title: activity.name,
          currentStep: currentStepNumber,
          totalSteps: totalSteps,
          accentColor: activity.accentColor,
          onExit: () {
            notifier.exitSession();
            if (context.mounted && context.canPop()) {
              context.pop();
            }
          },
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 16,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // 1. Barra horizontal de progreso segmentada por pasos
                        Row(
                          children: List.generate(totalSteps, (idx) {
                            final isPast = idx < state.currentStepIndex;
                            final isCurrent = idx == state.currentStepIndex;
                            return Expanded(
                              child: Container(
                                height: 5,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: isPast
                                      ? activity.accentColor
                                      : (isCurrent
                                          ? activity.accentColor
                                              .withValues(alpha: 0.6)
                                          : Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),

                        // 2. Visualizador biomecánico con cronómetro y dirección
                        RepaintBoundary(
                          child: RelaxationBodyVisualizer(
                            step: step,
                            remainingSeconds: state.stepRemainingSeconds,
                            isPlaying: state.isPlaying,
                            accentColor: activity.accentColor,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // 3. Tarjeta central de instrucción clara paso a paso
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Paso $currentStepNumber: ${step.title}',
                                style: TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                  color: activity.accentColor,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                step.instruction,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: MindColors.textPrimary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Consejo ergonómico
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F9F7),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.lightbulb_outline_rounded,
                                      size: 16,
                                      color: Color(0xFF2E7D32),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        step.ergonomicTip,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(height: 16),

                        // 4. Barra inferior de controles
                        ExerciseControlsBar(
                          isPlaying: state.isPlaying,
                          isLastStep: isLastStep,
                          accentColor: activity.accentColor,
                          onTogglePlay: notifier.togglePlayPause,
                          onPrevious: notifier.previousStep,
                          onNext: notifier.nextStep,
                          onResetStep: notifier.resetStep,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
