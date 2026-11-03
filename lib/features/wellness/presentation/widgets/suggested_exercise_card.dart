import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/wellness_suggested_exercise.dart';

/// Tarjeta serena destacada para el ejercicio diario sugerido de bienestar.
class SuggestedExerciseCard extends StatelessWidget {
  final WellnessSuggestedExercise exercise;
  final VoidCallback onStart;

  const SuggestedExerciseCard({
    super.key,
    required this.exercise,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MindColors.autocuidado,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: MindColors.primaryLight.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: MindColors.primaryDark.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cabecera con kicker, título, descripción e icono lateral
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.categoryLabel,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: MindColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exercise.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MindColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exercise.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: MindColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Icono en círculo verde menta
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: MindColors.bienestarPill,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.air,
                  size: 28,
                  color: MindColors.primaryDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 2. Fila inferior: Indicador de ciclo y botón de inicio rápido
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Indicador de ciclo guiado
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: MindColors.primaryDark,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    exercise.statusLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: MindColors.textPrimary,
                    ),
                  ),
                ],
              ),

              // Botón de cápsula: Comenzar (5 min)
              Material(
                color: MindColors.primaryDark,
                borderRadius: BorderRadius.circular(24),
                elevation: 1,
                shadowColor: MindColors.primaryDark.withValues(alpha: 0.25),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: onStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          exercise.actionLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
