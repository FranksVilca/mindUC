import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/relaxation_step.dart';

/// Visualizador interactivo animado del cuerpo humano, dirección biomecánica del movimiento
/// y cronómetro de arco circular para cada paso guiado.
class RelaxationBodyVisualizer extends StatefulWidget {
  final RelaxationStep step;
  final int remainingSeconds;
  final bool isPlaying;
  final Color accentColor;

  const RelaxationBodyVisualizer({
    super.key,
    required this.step,
    required this.remainingSeconds,
    required this.isPlaying,
    required this.accentColor,
  });

  @override
  State<RelaxationBodyVisualizer> createState() =>
      _RelaxationBodyVisualizerState();
}

class _RelaxationBodyVisualizerState extends State<RelaxationBodyVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (widget.isPlaying) {
      _animController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant RelaxationBodyVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_animController.isAnimating) {
      _animController.repeat(reverse: true);
    } else if (!widget.isPlaying && _animController.isAnimating) {
      _animController.stop();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    final totalDuration = step.durationSeconds;
    final progress = totalDuration > 0
        ? (1.0 - (widget.remainingSeconds / totalDuration)).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Contenedor principal con visualizador e ilustración
        SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Arco circular animado de progreso
              CustomPaint(
                size: const Size(240, 240),
                painter: _CircularProgressPainter(
                  progress: progress,
                  activeColor: widget.accentColor,
                  trackColor: widget.accentColor.withValues(alpha: 0.12),
                ),
              ),

              // 2. Fondo botánico sereno y pulsante
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  final scale = 1.0 + (_animController.value * 0.04);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: widget.accentColor.withValues(alpha: 0.15),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // 3. Ilustración biomecánica de la postura según visualType
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return _buildIllustrationContent(step.visualType);
                },
              ),

              // 4. Píldora de cuenta regresiva en el borde inferior del visualizador
              Positioned(
                bottom: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_rounded,
                        size: 13,
                        color: widget.accentColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${widget.remainingSeconds}s',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: widget.accentColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Etiqueta destacada: Parte del cuerpo intervenida y dirección
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: widget.accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.accentColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.adjust_rounded,
                size: 14,
                color: widget.accentColor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Zona activa: ${step.bodyPartFocus}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: widget.accentColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Indicador de dirección del movimiento
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_flat_rounded,
              size: 15,
              color: MindColors.textSecondary.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                'Dirección: ${step.movementDirection}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: MindColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIllustrationContent(RelaxationVisualType type) {
    final t = _animController.value;

    switch (type) {
      // Cuello
      case RelaxationVisualType.neckRight:
        return _buildNeckIllustration(tiltAngle: 0.18 + (t * 0.06), isRight: true);
      case RelaxationVisualType.neckHold:
        return _buildNeckIllustration(tiltAngle: 0.22, isRight: true, showRings: true);
      case RelaxationVisualType.neckCenter:
        return _buildNeckIllustration(tiltAngle: 0.0, isRight: false);
      case RelaxationVisualType.neckLeft:
        return _buildNeckIllustration(tiltAngle: -0.18 - (t * 0.06), isRight: false);
      case RelaxationVisualType.neckMobility:
        return _buildNeckMobilityIllustration(t);

      // Espalda
      case RelaxationVisualType.backSit:
        return _buildSpineSittingIllustration(t);
      case RelaxationVisualType.backReach:
        return _buildSpineReachIllustration(t);
      case RelaxationVisualType.backFold:
        return _buildSpineFoldIllustration(t);
      case RelaxationVisualType.backExtend:
        return _buildSpineExtendIllustration(t);
      case RelaxationVisualType.backRelax:
        return _buildSpineRelaxIllustration(t);

      // Mandíbula
      case RelaxationVisualType.jawRelax:
      case RelaxationVisualType.jawLocate:
      case RelaxationVisualType.jawCircles:
      case RelaxationVisualType.jawGlide:
      case RelaxationVisualType.jawRelease:
        return _buildJawIllustration(type, t);

      // Ojos / Visión
      case RelaxationVisualType.eyeLookAway:
      case RelaxationVisualType.eyeFocusDistance:
      case RelaxationVisualType.eyeBlink:
      case RelaxationVisualType.eyePalming:
      case RelaxationVisualType.eyeInfinity:
        return _buildVisionIllustration(type, t);
    }
  }

  // --- Ilustraciones Vectoriales / Biomecánicas Especializadas ---

  Widget _buildNeckIllustration({
    required double tiltAngle,
    required bool isRight,
    bool showRings = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: tiltAngle,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.accentColor.withValues(alpha: 0.15),
              border: Border.all(color: widget.accentColor, width: 2),
            ),
            child: Icon(
              Icons.face_rounded,
              size: 44,
              color: widget.accentColor,
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Hombros y torso base
        Container(
          width: 90,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Center(
            child: Icon(
              isRight ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
              size: 14,
              color: widget.accentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNeckMobilityIllustration(double t) {
    final angle = math.sin(t * math.pi) * 0.22;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: angle,
          child: Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.accentColor.withValues(alpha: 0.15),
              border: Border.all(color: widget.accentColor, width: 2),
            ),
            child: const Icon(
              Icons.sync_rounded,
              size: 40,
              color: MindColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Semicírculos suaves',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: widget.accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSpineSittingIllustration(double t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.airline_seat_recline_normal_rounded,
          size: 64,
          color: widget.accentColor,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Columna Erguida',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: MindColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpineReachIllustration(double t) {
    final lift = t * 6.0;
    return Transform.translate(
      offset: Offset(0, -lift),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pan_tool_rounded,
            size: 44,
            color: widget.accentColor,
          ),
          const SizedBox(height: 2),
          Icon(
            Icons.arrow_upward_rounded,
            size: 24,
            color: widget.accentColor,
          ),
          const SizedBox(height: 2),
          Text(
            'Alarga al cielo',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: widget.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpineFoldIllustration(double t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: 0.4 + (t * 0.08),
          child: Icon(
            Icons.accessibility_new_rounded,
            size: 60,
            color: widget.accentColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Flexión hacia adelante',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: widget.accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSpineExtendIllustration(double t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: -0.2 - (t * 0.06),
          child: Icon(
            Icons.accessibility_new_rounded,
            size: 60,
            color: widget.accentColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Apertura pectoral',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: widget.accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSpineRelaxIllustration(double t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.self_improvement_rounded,
          size: 64,
          color: widget.accentColor,
        ),
        const SizedBox(height: 4),
        Text(
          'Hombros en calma',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: widget.accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildJawIllustration(RelaxationVisualType type, double t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.accentColor.withValues(alpha: 0.12),
                border: Border.all(color: widget.accentColor, width: 2),
              ),
              child: const Icon(
                Icons.face_retouching_natural_rounded,
                size: 48,
                color: MindColors.saludMental,
              ),
            ),
            // Puntos pulsantes sobre maseteros
            Positioned(
              left: 10,
              bottom: 22,
              child: Container(
                width: 10 + (t * 4),
                height: 10 + (t * 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.accentColor.withValues(alpha: 0.6),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 22,
              child: Container(
                width: 10 + (t * 4),
                height: 10 + (t * 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.accentColor.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          type == RelaxationVisualType.jawCircles
              ? 'Masaje circular ATM'
              : 'Descarga mandibular',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: widget.accentColor,
          ),
        ),
      ],
    );
  }

  Widget _buildVisionIllustration(RelaxationVisualType type, double t) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (type == RelaxationVisualType.eyePalming) ...[
          const Icon(
            Icons.back_hand_rounded,
            size: 54,
            color: MindColors.autocuidado,
          ),
          const SizedBox(height: 6),
          const Text(
            'Calor y oscuridad',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: MindColors.autocuidado,
            ),
          ),
        ] else if (type == RelaxationVisualType.eyeInfinity) ...[
          const Icon(
            Icons.all_inclusive_rounded,
            size: 56,
            color: MindColors.autocuidado,
          ),
          const SizedBox(height: 6),
          const Text(
            'Movimiento en 8',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: MindColors.autocuidado,
            ),
          ),
        ] else ...[
          Icon(
            type == RelaxationVisualType.eyeBlink
                ? Icons.visibility_rounded
                : Icons.landscape_rounded,
            size: 54,
            color: widget.accentColor,
          ),
          const SizedBox(height: 6),
          Text(
            type == RelaxationVisualType.eyeFocusDistance
                ? 'Mirada al infinito (>6m)'
                : 'Pausa de pantallas',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: widget.accentColor,
            ),
          ),
        ],
      ],
    );
  }
}

/// Painter de precisión para el anillo exterior de cuenta regresiva del paso
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color trackColor;

  const _CircularProgressPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Pista de fondo completa
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Arco activo de progreso
    final progressPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor;
  }
}
