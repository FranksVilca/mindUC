import 'package:flutter/material.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/theme/mind_colors.dart';

/// Encabezado sereno de la sesión guiada con retroceso, título del ejercicio y contador de pasos.
class ExerciseHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onExit;
  final Color accentColor;

  const ExerciseHeader({
    super.key,
    required this.title,
    required this.currentStep,
    required this.totalSteps,
    required this.onExit,
    required this.accentColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Botón cerrar / salir y logotipo a la izquierda
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(color: MindColors.divider, width: 1),
                  ),
                  child: InkWell(
                    key: const Key('btn_exercise_exit'),
                    customBorder: const CircleBorder(),
                    onTap: onExit,
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: MindColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const MindAppLogo(size: 28),
              ],
            ),
            const SizedBox(width: 14),

            // Título de la rutina
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: MindColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Pausa activa guiada',
                    style: TextStyle(
                      fontSize: 11,
                      color: MindColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Badge de progreso del paso
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                'Paso $currentStep de $totalSteps',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
