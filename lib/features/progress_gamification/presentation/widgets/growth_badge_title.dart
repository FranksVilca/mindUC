import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Bloque de apertura de la pantalla con insignia botánica, título y lema compasivo.
class GrowthBadgeTitle extends StatelessWidget {
  const GrowthBadgeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Insignia de categoría
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F0E7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFCEE3D5),
                width: 0.8,
              ),
            ),
            child: const Text(
              '🌱 Crecimiento consciente',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C4C3B),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Título principal
          const Text(
            'Mi Progreso & Florecimiento',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: MindColors.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),

          // Lema de acompañamiento compasivo (Principio III)
          const Text(
            'Celebrando cada paso hacia tu bienestar, a tu propio ritmo.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.35,
              color: MindColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

