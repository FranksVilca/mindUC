import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/weekly_pause_metrics.dart';

/// Cuadrícula 2x2 que expone los momentos de pausa semanales (Principio III).
class WeeklyPauseGrid extends StatelessWidget {
  const WeeklyPauseGrid({
    super.key,
    required this.metrics,
  });

  final WeeklyPauseMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de sección
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Momentos de pausa',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: MindColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Esta semana',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: MindColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fila 1: Respiración y Pomodoro
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.air_rounded,
                  iconBg: const Color(0xFFD4EBE1),
                  iconColor: const Color(0xFF386B5A),
                  value: '${metrics.breathingMinutes} min',
                  description: 'Respiración consciente y calma interior',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.timer_rounded,
                  iconBg: const Color(0xFFEBE6F7),
                  iconColor: const Color(0xFF6B5899),
                  value: '${metrics.pomodoroSessions} sesiones',
                  description: 'Enfoque amable Pomodoro completado',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fila 2: Diario y Equilibrio
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.edit_note_rounded,
                  iconBg: const Color(0xFFFDECE8),
                  iconColor: const Color(0xFFD67868),
                  value: '${metrics.journalEntriesCount} reflexiones',
                  description: 'Entradas sinceras en diario íntimo',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.balance_rounded,
                  iconBg: const Color(0xFFE6EFEA),
                  iconColor: const Color(0xFF5D8572),
                  value: '${metrics.balancePercentage}%',
                  description: 'Equilibrio y descanso semanal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MindColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MindColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: MindColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.3,
              color: MindColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

