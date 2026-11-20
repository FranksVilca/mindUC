import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Barra inferior de controles para pausar, reanudar y navegar entre pasos de la rutina guiada.
class ExerciseControlsBar extends StatelessWidget {
  final bool isPlaying;
  final bool isLastStep;
  final VoidCallback onTogglePlay;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onResetStep;
  final Color accentColor;

  const ExerciseControlsBar({
    super.key,
    required this.isPlaying,
    required this.isLastStep,
    required this.onTogglePlay,
    required this.onPrevious,
    required this.onNext,
    required this.onResetStep,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Botón reiniciar paso actual
            IconButton(
              key: const Key('btn_exercise_reset_step'),
              tooltip: 'Reiniciar paso',
              onPressed: onResetStep,
              icon: const Icon(Icons.refresh_rounded),
              iconSize: 22,
              color: MindColors.textSecondary,
            ),
            const SizedBox(width: 8),

            // 2. Botón paso anterior
            IconButton(
              key: const Key('btn_exercise_prev_step'),
              tooltip: 'Paso anterior',
              onPressed: onPrevious,
              icon: const Icon(Icons.skip_previous_rounded),
              iconSize: 28,
              color: MindColors.textPrimary,
            ),
            const SizedBox(width: 14),

            // 3. Botón central Play / Pausa
            InkWell(
              key: const Key('btn_exercise_toggle_play'),
              onTap: onTogglePlay,
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // 4. Botón siguiente paso o terminar
            IconButton(
              key: const Key('btn_exercise_next_step'),
              tooltip: isLastStep ? 'Finalizar rutina' : 'Siguiente paso',
              onPressed: onNext,
              icon: Icon(
                isLastStep ? Icons.check_circle_rounded : Icons.skip_next_rounded,
                color: isLastStep ? Colors.green.shade700 : MindColors.textPrimary,
              ),
              iconSize: 28,
            ),
          ],
        ),
      ),
    );
  }
}
