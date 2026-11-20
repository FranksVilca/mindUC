import 'package:flutter/material.dart';
import 'package:minduc/core/theme/mind_colors.dart';

/// Fila de controles de sesión de respiración: Reiniciar, Cápsula Play/Pausa y Detener.
class BreathingControlsRow extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onReset;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;

  const BreathingControlsRow({
    super.key,
    required this.isRunning,
    required this.onReset,
    required this.onPlayPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Botón circular de reinicio (izquierda)
          _CircularControlButton(
            icon: Icons.refresh,
            tooltip: 'Reiniciar sesión',
            onTap: onReset,
          ),

          const SizedBox(width: 16),

          // 2. Botón principal en cápsula (centro)
          Material(
            color: MindColors.primaryDark,
            borderRadius: BorderRadius.circular(30),
            elevation: 2,
            shadowColor: MindColors.primaryDark.withValues(alpha: 0.3),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onPlayPause,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isRunning ? 'Pausar sesión' : 'Iniciar sesión',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 3. Botón circular de parada (derecha)
          _CircularControlButton(
            icon: Icons.stop,
            tooltip: 'Detener sesión',
            onTap: onStop,
          ),
        ],
      ),
    );
  }
}

class _CircularControlButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _CircularControlButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(
        side: BorderSide(color: MindColors.divider, width: 1.2),
      ),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              icon,
              color: MindColors.textSecondary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
