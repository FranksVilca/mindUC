import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/agenda_activity.dart';

/// Tarjeta individual de actividad consciente en la agenda.
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    required this.onToggleComplete,
    this.onTap,
    this.onEdit,
  });

  final AgendaActivity activity;
  final VoidCallback onToggleComplete;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit ?? onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector circular de completado
            GestureDetector(
              key: Key('activity_toggle_${activity.id}'),
              onTap: onToggleComplete,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 26,
                height: 26,
                margin: const EdgeInsets.only(top: 2, right: 14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activity.isCompleted
                      ? const Color(0xFF90C2A8) // Verde menta activo
                      : const Color(0xFFEFEBE6), // Beige sutil inactivo
                ),
                child: activity.isCompleted
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 17,
                      )
                    : null,
              ),
            ),

            // Contenido de la actividad
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila superior: Hora, Chip de Categoría y Botón de Edición
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          activity.formattedTime,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: MindColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: activity.category.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: activity.category.accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  activity.category.chipLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: activity.category.accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (onEdit != null) ...[
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: onEdit,
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 15,
                                  color: MindColors.textTertiary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Título de la actividad (tachado condicional)
                  Text(
                    activity.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: activity.isCompleted
                          ? const Color(0xFF757575)
                          : MindColors.textPrimary,
                      decoration: activity.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: const Color(0xFF757575),
                      height: 1.25,
                    ),
                  ),

                  // Subtítulo / Descripción
                  if (activity.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      activity.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: MindColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
