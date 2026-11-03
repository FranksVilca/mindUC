import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Barra de progreso de ciclos Pomodoro con etiqueta contextual ("Sesión de la tarde"),
/// insignia de ciclo ("Ciclo X de Y") y 4 segmentos horizontales.
class PomodoroCycleProgress extends StatelessWidget {
  const PomodoroCycleProgress({
    super.key,
    required this.sessionTitle,
    required this.currentCycle,
    this.totalCycles = 4,
  });

  final String sessionTitle;
  final int currentCycle;
  final int totalCycles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fila de contexto e indicador de ciclo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MindColors.bienestarPill,
                  ),
                  child: const Icon(
                    Icons.spa_rounded,
                    size: 15,
                    color: MindColors.primaryDark,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  sessionTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MindColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Ciclo $currentCycle de $totalCycles',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Barra segmentada de 4 cápsulas horizontales
        Row(
          children: List.generate(totalCycles, (index) {
            final cycleNumber = index + 1;
            Color barColor;
            if (cycleNumber < currentCycle) {
              barColor = MindColors.primaryDark;
            } else if (cycleNumber == currentCycle) {
              barColor = MindColors.primary;
            } else {
              barColor = Colors.grey.shade300;
            }

            return Expanded(
              child: Container(
                height: 8,
                margin: EdgeInsets.only(
                  right: index < totalCycles - 1 ? 6.0 : 0.0,
                ),
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

