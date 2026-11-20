import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/relaxation_activity.dart';

/// Tarjeta moderna representativa de cada actividad de relajación y pausa activa.
class ActivityCard extends StatelessWidget {
  final RelaxationActivity activity;
  final VoidCallback onStart;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = activity.isCompletedToday;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDone
                  ? MindColors.primary.withValues(alpha: 0.3)
                  : Colors.grey.shade200,
              width: isDone ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF222E28).withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Fila superior: Ilustración / icono representativo y píldora de duración / estado
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenedor ilustrativo gráfico
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: activity.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: activity.accentColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Center(
                  child: Icon(
                    activity.icon,
                    size: 30,
                    color: activity.accentColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Título, zona corporal y etiqueta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            activity.targetArea.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: activity.accentColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Badge de duración
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.schedule_rounded,
                                size: 12,
                                color: MindColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                activity.estimatedDurationText,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: MindColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.name,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: MindColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 2. Breve descripción del beneficio
          Text(
            activity.benefit,
            style: const TextStyle(
              fontSize: 13,
              color: MindColors.textSecondary,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 14),

          // 3. Fila inferior: Estado de realización e indicador interactivo con botón
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Indicador de estado de realización
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDone
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFF5F7F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDone
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 14,
                        color: isDone ? Colors.green.shade700 : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          isDone
                              ? (activity.completionsCount > 1
                                  ? 'Completado (${activity.completionsCount}x hoy) ✨'
                                  : 'Completado hoy ✨')
                              : 'Pendiente',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDone ? Colors.green.shade800 : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Botón de acción Comenzar / Repetir
              ElevatedButton.icon(
                key: Key('btn_start_${activity.id}'),
                onPressed: onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDone
                      ? const Color(0xFFE6EFEA)
                      : MindColors.primary,
                  foregroundColor: isDone ? MindColors.primary : Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: Icon(
                  isDone ? Icons.replay_rounded : Icons.play_arrow_rounded,
                  size: 18,
                ),
                label: Text(
                  isDone ? 'Repetir' : 'Comenzar',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
  }
}
