import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_mood_pulse.dart';

/// Tarjeta que representa una huella interior en la cronología del diario íntimo.
class JournalEntryCard extends StatelessWidget {
  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  final JournalEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Color _badgeBackgroundColor(JournalMoodPulse pulse) {
    switch (pulse) {
      case JournalMoodPulse.enCalma:
        return MindColors.bienestarPill;
      case JournalMoodPulse.agradecida:
        return const Color(0xFFF9F3D8);
      case JournalMoodPulse.reflexiva:
        return MindColors.estudioTrabajo;
      case JournalMoodPulse.cansada:
        return Colors.grey.shade200;
      case JournalMoodPulse.abrumada:
        return MindColors.saludMental;
    }
  }

  Color _badgeTextColor(JournalMoodPulse pulse) {
    switch (pulse) {
      case JournalMoodPulse.enCalma:
        return MindColors.primaryDark;
      case JournalMoodPulse.agradecida:
        return const Color(0xFF7A6B29);
      case JournalMoodPulse.reflexiva:
        return MindColors.estudioTrabajoAccent;
      case JournalMoodPulse.cansada:
        return Colors.grey.shade700;
      case JournalMoodPulse.abrumada:
        return MindColors.saludMentalAccent;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          '¿Eliminar huella interior?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: MindColors.textPrimary,
          ),
        ),
        content: const Text(
          'Esta reflexión se borrará definitivamente de tu dispositivo. '
          'Esta acción no se puede deshacer.',
          style: TextStyle(
            fontSize: 13,
            color: MindColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Conservar',
              style: TextStyle(color: MindColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MindColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _badgeBackgroundColor(entry.moodPulse);
    final txtColor = _badgeTextColor(entry.moodPulse);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: badge emocional, fecha y acciones
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  entry.moodPulse.chipText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: txtColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.formattedDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: MindColors.textSecondary,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: MindColors.textSecondary,
                ),
                splashRadius: 18,
                tooltip: 'Editar reflexión',
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  size: 18,
                  color: MindColors.textSecondary,
                ),
                tooltip: 'Opciones',
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            size: 18, color: MindColors.error),
                        SizedBox(width: 8),
                        Text('Eliminar',
                            style: TextStyle(color: MindColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Título de la reflexión
          Text(
            entry.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.25,
              color: MindColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),

          // Extracto del texto
          Text(
            entry.previewSnippet,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: MindColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),

          // Pie de privacidad y tiempo de lectura
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 13,
                      color: MindColors.textSecondary,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Solo visible en este teléfono',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: MindColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry.readingTimeString,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: MindColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

