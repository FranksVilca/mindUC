import 'package:flutter/material.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/theme/mind_colors.dart';

/// Barra superior de navegación para la pantalla de Concentración Pomodoro.
class PomodoroHeader extends StatelessWidget {
  const PomodoroHeader({
    super.key,
    required this.onBack,
    this.onOptions,
  });

  final VoidCallback onBack;
  final VoidCallback? onOptions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: MindColors.textPrimary,
                ),
                splashRadius: 22,
                tooltip: 'Volver',
              ),
              const SizedBox(width: 4),
              const MindAppLogo(size: 28),
            ],
          ),
          const Column(
            children: [
              Text(
                'Minduc — Concentración\n(Pomodoro)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: MindColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'mindUC',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: MindColors.textSecondary,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onOptions ?? () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 22,
              color: MindColors.textPrimary,
            ),
            splashRadius: 22,
            tooltip: 'Opciones',
          ),
        ],
      ),
    );
  }
}

