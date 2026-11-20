import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Tarjeta de balance consciente "Ritmo en equilibrio".
class RhythmBalanceCard extends StatelessWidget {
  const RhythmBalanceCard({
    super.key,
    required this.totalActivities,
    required this.completedActivities,
    this.onHistoryTap,
  });

  final int totalActivities;
  final int completedActivities;
  final VoidCallback? onHistoryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono circular con acento botánico y borde concéntrico
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF3B5648).withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.spa_rounded,
                color: Color(0xFF3B5648),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Título y conteo de actividades
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ritmo en equilibrio',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: MindColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$totalActivities actividades · $completedActivities completadas',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: MindColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Enlace a Historial
          GestureDetector(
            onTap: onHistoryTap,
            behavior: HitTestBehavior.opaque,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Historial',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5A7264),
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Color(0xFF5A7264),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

