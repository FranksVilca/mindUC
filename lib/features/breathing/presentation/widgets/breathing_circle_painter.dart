import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:minduc/core/theme/mind_colors.dart';

/// Painter que dibuja el anillo perimetral guía y el arco continuo
/// de progreso temporal de la fase activa de respiración.
class BreathingCirclePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;

  const BreathingCirclePainter({
    required this.progress,
    this.progressColor = MindColors.primaryDark,
    this.trackColor = const Color(0xFFD8E4DC),
    this.strokeWidth = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    // 1. Dibujar pista base de fondo (anillo sutil)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // 2. Anillo de guía perimetral punteado suave
    final dashedPaint = Paint()
      ..color = trackColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashCount = 36;
    const dashSweep = (2 * math.pi) / dashCount;
    for (int i = 0; i < dashCount; i++) {
      final angle = i * dashSweep;
      final outerX = center.dx + (radius + 10) * math.cos(angle);
      final outerY = center.dy + (radius + 10) * math.sin(angle);
      canvas.drawCircle(Offset(outerX, outerY), 1.2, dashedPaint);
    }

    // 3. Dibujar arco de progreso de la fase activa (comenzando arriba en -pi/2)
    if (progress > 0.001) {
      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BreathingCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
