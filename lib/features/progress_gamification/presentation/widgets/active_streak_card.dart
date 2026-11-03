import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/active_streak.dart';

/// Tarjeta de racha de autocuidado activo y constancia orgánica (Principio III).
/// No genera culpa ni ansiedad por pausas; celebra cada paso dado a propio ritmo.
class ActiveStreakCard extends StatelessWidget {
  const ActiveStreakCard({
    super.key,
    required this.streak,
  });

  final ActiveStreak streak;

  static const List<String> _weekdayLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD6E4DB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Etiqueta superior y distintivo floral
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'RACHA DE AUTOCUIDADO ACTIVO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: Color(0xFF3B5648),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  size: 18,
                  color: Color(0xFF3B5648),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 2. Métrica principal: 7 días consecutivos
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${streak.daysCount} días',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: MindColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'consecutivos',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: MindColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 3. Mensaje empático botánico
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.eco_rounded,
                  size: 16,
                  color: Color(0xFF5D8572),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  streak.message,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.35,
                    color: Color(0xFF3B5648),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. Franja semanal de 7 días (L M X J V S D)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(4),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final label = _weekdayLabels[index];
                final isCompleted = streak.isDayCompleted(index);
                final isCurrentDay = index == streak.currentDayIndex;

                Color circleColor;
                Widget iconWidget;

                if (isCurrentDay && isCompleted) {
                  circleColor = const Color(0xFF2C4C3B);
                  iconWidget = const Icon(
                    Icons.spa_rounded,
                    size: 14,
                    color: Colors.white,
                  );
                } else if (isCompleted) {
                  circleColor = const Color(0xFFD3E6DA);
                  iconWidget = const Icon(
                    Icons.eco_rounded,
                    size: 14,
                    color: Color(0xFF2C4C3B),
                  );
                } else {
                  circleColor = const Color(0xFFF2EFE8);
                  iconWidget = const SizedBox.shrink();
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: MindColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: circleColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: iconWidget),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

