import 'package:flutter/material.dart';
import 'package:minduc/core/theme/mind_colors.dart';

/// Diálogo modal sereno desplegado al finalizar la sesión guiada de respiración.
class BreathingSummaryDialog extends StatelessWidget {
  final int durationSeconds;
  final int cyclesCompleted;
  final String techniqueName;
  final VoidCallback onReturnHome;
  final VoidCallback onRepeat;

  const BreathingSummaryDialog({
    super.key,
    required this.durationSeconds,
    required this.cyclesCompleted,
    required this.techniqueName,
    required this.onReturnHome,
    required this.onRepeat,
  });

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    if (mins == 0) return '$secs seg';
    if (secs == 0) return '$mins min';
    return '$mins min $secs s';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Icono de bienestar sereno
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: MindColors.autocuidado,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.spa,
                size: 32,
                color: MindColors.primaryDark,
              ),
            ),
            const SizedBox(height: 18),

            // 2. Felicitación serena
            const Text(
              '¡Pausa consciente completada! 🌿',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: MindColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Has dedicado un momento valioso para tu bienestar mental y calma.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: MindColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // 3. Resumen de métricas alcanzadas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: MindColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: MindColors.divider, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        _formatDuration(durationSeconds),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MindColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tiempo dedicado',
                        style: TextStyle(
                          fontSize: 11,
                          color: MindColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 32,
                    width: 1,
                    color: MindColors.divider,
                  ),
                  Column(
                    children: [
                      Text(
                        '$cyclesCompleted',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MindColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Ciclos completados',
                        style: TextStyle(
                          fontSize: 11,
                          color: MindColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Botón primario: Volver al inicio
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MindColors.primaryDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: onReturnHome,
                child: const Text(
                  'Volver al inicio',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 5. Botón secundario: Hacer otra pausa
            TextButton(
              onPressed: onRepeat,
              child: const Text(
                'Hacer otra pausa',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MindColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
