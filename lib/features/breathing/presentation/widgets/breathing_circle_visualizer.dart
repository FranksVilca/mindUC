import 'package:flutter/material.dart';
import 'package:minduc/core/theme/mind_colors.dart';
import 'package:minduc/features/breathing/domain/entities/breathing_phase.dart';
import 'package:minduc/features/breathing/presentation/widgets/breathing_circle_painter.dart';

/// Visualizador circular animado a 60 fps para guiado biomecánico de respiración.
class BreathingCircleVisualizer extends StatefulWidget {
  final BreathingPhase phase;
  final int secondsRemaining;
  final double phaseProgressFraction;
  final bool isRunning;
  final double size;

  const BreathingCircleVisualizer({
    super.key,
    required this.phase,
    required this.secondsRemaining,
    required this.phaseProgressFraction,
    this.isRunning = true,
    this.size = 260.0,
  });

  @override
  State<BreathingCircleVisualizer> createState() => _BreathingCircleVisualizerState();
}

class _BreathingCircleVisualizerState extends State<BreathingCircleVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.20).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _syncAnimationTarget();
  }

  @override
  void didUpdateWidget(covariant BreathingCircleVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase || oldWidget.isRunning != widget.isRunning) {
      _syncAnimationTarget();
    }
  }

  void _syncAnimationTarget() {
    if (!widget.isRunning) {
      _animController.stop();
      return;
    }

    final duration = Duration(
      seconds: widget.secondsRemaining > 0 ? widget.secondsRemaining : 1,
    );
    _animController.duration = duration;

    switch (widget.phase) {
      case BreathingPhase.inhale:
        _animController.forward();
        break;
      case BreathingPhase.hold:
        // Se mantiene en escala expandida durante la retención
        _animController.value = 1.0;
        break;
      case BreathingPhase.exhale:
        _animController.reverse();
        break;
      case BreathingPhase.rest:
        _animController.value = 0.0;
        break;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final innerCircleSize = widget.size * 0.82;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Arco de progreso perimetral y anillo exterior
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: BreathingCirclePainter(
              progress: widget.phaseProgressFraction,
              progressColor: MindColors.primaryDark,
              trackColor: MindColors.primaryLight.withValues(alpha: 0.35),
              strokeWidth: 6.0,
            ),
          ),

          // 2. Círculo botánico central con escalado biomecánico
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: innerCircleSize,
              height: innerCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MindColors.autocuidado,
                boxShadow: [
                  BoxShadow(
                    color: MindColors.primaryDark.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono de aire sereno
                    const Icon(
                      Icons.air,
                      size: 26,
                      color: MindColors.primaryDark,
                    ),
                    const SizedBox(height: 8),

                    // Instrucción de la fase
                    Text(
                      widget.phase.instruction,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MindColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Segundero numérico
                    Text(
                      '${widget.secondsRemaining}s',
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: MindColors.primaryDark,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Guía biomecánica corporal en mayúsculas espaciadas
                    Text(
                      widget.phase.biomechanicalHint,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: MindColors.textSecondary,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
