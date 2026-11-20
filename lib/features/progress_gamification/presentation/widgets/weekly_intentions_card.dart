import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/weekly_intention.dart';

/// Tarjeta de intenciones amables semanales con avance interactivo (Principio III).
class WeeklyIntentionsCard extends StatelessWidget {
  const WeeklyIntentionsCard({
    super.key,
    required this.intentions,
    required this.onToggleIntention,
  });

  final List<WeeklyIntention> intentions;
  final ValueChanged<String> onToggleIntention;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MindColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MindColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Encabezado con icono compasivo de corazón
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Intenciones de la semana',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: MindColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Metas sin prisa, enfocadas en sentirte bien',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: MindColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFD6EADA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 16,
                  color: Color(0xFF386B5A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2. Lista de intenciones o estado en blanco
          if (intentions.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F7F2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: MindColors.divider),
              ),
              child: const Text(
                'Tus intenciones se generarán con tus primeras prácticas conscientes en la plataforma 🌿',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: MindColors.textSecondary,
                  height: 1.35,
                ),
              ),
            )
          else
            Column(
              children: intentions.map((intention) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => onToggleIntention(intention.id),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F7F2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: intention.isCompleted
                              ? const Color(0xFFCEE3D5)
                              : MindColors.divider,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icono de estado / tipo
                          _buildLeadingIcon(intention),
                          const SizedBox(width: 12),

                          // Contenido y barra de progreso
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        intention.title,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: intention.isCompleted
                                              ? MindColors.textSecondary
                                              : MindColors.textPrimary,
                                          decoration: intention.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (!intention.isCompleted)
                                      Text(
                                        '${intention.currentUnits} / ${intention.targetUnits} ${intention.unitLabel}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: MindColors.textSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (intention.isCompleted)
                                  Text(
                                    '${intention.currentUnits} de ${intention.targetUnits} ${intention.unitLabel}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF3B5648),
                                    ),
                                  )
                                else ...[
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: intention.progressRatio,
                                      minHeight: 5,
                                      backgroundColor: const Color(0xFFE5DFD3),
                                      valueColor: const AlwaysStoppedAnimation(
                                        Color(0xFF3F5E4D),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(WeeklyIntention intention) {
    if (intention.isCompleted) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Color(0xFF3F5E4D),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 16,
          color: Colors.white,
        ),
      );
    }

    IconData icon;
    switch (intention.iconType) {
      case IntentionIconType.walk:
        icon = Icons.hourglass_empty_rounded;
        break;
      case IntentionIconType.screens:
        icon = Icons.nightlight_round;
        break;
      case IntentionIconType.pauses:
        icon = Icons.pause_circle_outline_rounded;
        break;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: MindColors.divider),
      ),
      child: Icon(
        icon,
        size: 15,
        color: const Color(0xFF5D756A),
      ),
    );
  }
}
