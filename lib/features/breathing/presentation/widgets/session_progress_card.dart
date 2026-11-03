import 'package:flutter/material.dart';
import 'package:minduc/core/theme/mind_colors.dart';

/// Tarjeta serena que muestra el tiempo restante de la sesión y una barra lineal de avance.
class SessionProgressCard extends StatelessWidget {
  final int elapsedSeconds;
  final int targetSeconds;
  final double progressFraction;

  const SessionProgressCard({
    super.key,
    required this.elapsedSeconds,
    required this.targetSeconds,
    required this.progressFraction,
  });

  String _formatDigital(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final bool isFreeMode = targetSeconds <= 0;
    final int remainingSeconds = isFreeMode
        ? elapsedSeconds
        : (targetSeconds - elapsedSeconds).clamp(0, targetSeconds);

    final String timeDisplay = isFreeMode
        ? _formatDigital(elapsedSeconds)
        : '${_formatDigital(remainingSeconds)} / ${_formatDigital(targetSeconds)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MindColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    size: 18,
                    color: MindColors.primaryDark,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isFreeMode ? 'Tiempo transcurrido' : 'Tiempo restante',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: MindColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                timeDisplay,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MindColors.textPrimary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: isFreeMode ? null : progressFraction.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: MindColors.surfaceSubtle,
              valueColor: const AlwaysStoppedAnimation<Color>(MindColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}
