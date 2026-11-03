import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Diálogo sereno informativo sobre la fase de preparación del Asistente IA,
/// en estricto cumplimiento del Principio VI de la Constitución de mindUC.
class AiAssistantComingSoonDialog extends StatelessWidget {
  final VoidCallback onDismiss;

  const AiAssistantComingSoonDialog({
    super.key,
    required this.onDismiss,
  });

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
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: MindColors.descanso,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 28,
                color: MindColors.primaryDark,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Acompañamiento en Preparación ✨',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MindColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'El Asistente IA de mindUC está en proceso de validación ética, compasiva y privada para resguardar la salud mental de la comunidad universitaria.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: MindColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MindColors.primaryDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
                onPressed: onDismiss,
                child: const Text(
                  'Comprendido',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
