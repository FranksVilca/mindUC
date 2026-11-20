import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/pomodoro_state.dart';

/// Tarjeta principal de la sesión Pomodoro que contiene el objetivo en curso,
/// el cronómetro circular visual y los controles de reproducción.
class PomodoroTimerCard extends StatelessWidget {
  const PomodoroTimerCard({
    super.key,
    required this.state,
    required this.onToggleTimer,
    required this.onResetInterval,
    required this.onSkipInterval,
    required this.onEditObjective,
  });

  final PomodoroState state;
  final VoidCallback onToggleTimer;
  final VoidCallback onResetInterval;
  final VoidCallback onSkipInterval;
  final VoidCallback onEditObjective;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Subtarjeta de objetivo académico
          _ObjectiveHeader(
            objective: state.currentObjective,
            onEdit: onEditObjective,
          ),
          const SizedBox(height: 24),

          // Cronómetro circular visual
          _CircularTimerVisualizer(
            progress: state.progress,
            remainingTime: state.formattedRemainingTime,
            totalTime: state.formattedTotalTime,
            isRunning: state.isRunning,
          ),
          const SizedBox(height: 24),

          // Fila de controles de reproducción responsiva
          _ControlsRow(
            isRunning: state.isRunning,
            onToggle: onToggleTimer,
            onReset: onResetInterval,
            onSkip: onSkipInterval,
          ),
        ],
      ),
    );
  }
}

class _ObjectiveHeader extends StatelessWidget {
  const _ObjectiveHeader({
    required this.objective,
    required this.onEdit,
  });

  final String objective;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: MindColors.surfaceSubtle.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.bookmark_rounded,
            color: MindColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OBJETIVO EN CURSO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  objective,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: MindColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: MindColors.textSecondary,
            ),
            splashRadius: 20,
            tooltip: 'Editar objetivo',
          ),
        ],
      ),
    );
  }
}

class _CircularTimerVisualizer extends StatelessWidget {
  const _CircularTimerVisualizer({
    required this.progress,
    required this.remainingTime,
    required this.totalTime,
    required this.isRunning,
  });

  final double progress;
  final String remainingTime;
  final String totalTime;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RepaintBoundary(
            child: CustomPaint(
              size: const Size(220, 220),
              painter: _PomodoroCirclePainter(
                progress: progress,
                activeColor: MindColors.primary.withValues(alpha: 0.85),
                trackColor: Colors.grey.shade200,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRunning
                          ? MindColors.primary
                          : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isRunning ? 'Bloque activo' : 'En pausa',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isRunning
                          ? MindColors.primary
                          : MindColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                remainingTime,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                  color: MindColors.textPrimary,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                totalTime,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: MindColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PomodoroCirclePainter extends CustomPainter {
  const _PomodoroCirclePainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
  });

  final double progress;
  final Color activeColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Pista de fondo completa (360°)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Arco de progreso activo
    final arcPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Comenzamos desde las 12:00 (-pi / 2)
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Pequeño indicador circular en la cabeza del arco si hay progreso
    if (progress > 0.01 && progress < 0.99) {
      final headAngle = startAngle + sweepAngle;
      final headX = center.dx + radius * math.cos(headAngle);
      final headY = center.dy + radius * math.sin(headAngle);

      final dotPaint = Paint()
        ..color = MindColors.primary
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(headX, headY), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PomodoroCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor;
  }
}

class _ControlsRow extends StatelessWidget {
  const _ControlsRow({
    required this.isRunning,
    required this.onToggle,
    required this.onReset,
    required this.onSkip,
  });

  final bool isRunning;
  final VoidCallback onToggle;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón Reiniciar (↺)
          _CircleIconButton(
            icon: Icons.refresh_rounded,
            onTap: onReset,
            tooltip: 'Reiniciar intervalo',
          ),
          const SizedBox(width: 12),

          // Botón Central Píldora
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFB5CFB7), // Tono salvia relajante del mockup
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: const Color(0xFF2C3E2D),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isRunning ? 'Pausar enfoque' : 'Iniciar enfoque',
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E2D),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Botón Saltar (>|)
          _CircleIconButton(
            icon: Icons.skip_next_rounded,
            onTap: onSkip,
            tooltip: 'Saltar intervalo',
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade100,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: MindColors.textSecondary, size: 20),
        tooltip: tooltip,
      ),
    );
  }
}
