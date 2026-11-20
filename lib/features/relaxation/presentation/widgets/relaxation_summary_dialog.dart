import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Modal sereno y compasivo de felicitación al culminar una pausa activa guiada.
class RelaxationSummaryDialog extends StatelessWidget {
  final String activityName;
  final int totalSeconds;
  final int stepsCount;
  final VoidCallback onReturn;
  final VoidCallback onRepeat;

  const RelaxationSummaryDialog({
    super.key,
    required this.activityName,
    required this.totalSeconds,
    required this.stepsCount,
    required this.onReturn,
    required this.onRepeat,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (totalSeconds / 60).ceil();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Icono botánico animado de celebración
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8F5E9),
                border: Border.all(
                  color: Colors.green.shade300,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.spa_rounded,
                  size: 40,
                  color: MindColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Título principal
            const Text(
              '¡Pausa completada con éxito! ✨',
              style: TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.bold,
                color: MindColors.textPrimary,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // Subtítulo
            const Text(
              'Has regalado a tu cuerpo un momento vital de descanso y oxigenación.',
              style: TextStyle(
                fontSize: 13,
                color: MindColors.textSecondary,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),

            // Tarjeta de resumen de métricas
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9F7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildMetric('Actividad', activityName)),
                  Container(width: 1, height: 32, color: Colors.grey.shade300),
                  Expanded(child: _buildMetric('Tiempo de alivio', '$minutes min')),
                  Container(width: 1, height: 32, color: Colors.grey.shade300),
                  Expanded(child: _buildMetric('Pasos', '$stepsCount de $stepsCount')),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Botón principal: Volver a Relajación
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                key: const Key('btn_summary_return_relaxation'),
                onPressed: onReturn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MindColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Volver a Relajación',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Botón secundario: Repetir pausa
            SizedBox(
              width: double.infinity,
              height: 42,
              child: TextButton.icon(
                key: const Key('btn_summary_repeat_exercise'),
                onPressed: onRepeat,
                icon: const Icon(Icons.replay_rounded, size: 16),
                label: const Text(
                  'Repetir este ejercicio',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: MindColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: MindColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: MindColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
