import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/journal_mood_pulse.dart';

/// Tarjeta del selector emocional "¿Cómo late tu corazón hoy?"
/// con las 5 opciones de pulso y acento visual botánico en el estado activo.
class EmotionalPulseSelector extends StatelessWidget {
  const EmotionalPulseSelector({
    super.key,
    required this.selectedPulse,
    required this.onPulseSelected,
  });

  final JournalMoodPulse selectedPulse;
  final ValueChanged<JournalMoodPulse> onPulseSelected;

  IconData _iconForPulse(JournalMoodPulse pulse) {
    switch (pulse) {
      case JournalMoodPulse.agradecida:
        return Icons.auto_awesome_rounded;
      case JournalMoodPulse.enCalma:
        return Icons.local_florist_rounded;
      case JournalMoodPulse.reflexiva:
        return Icons.spa_rounded;
      case JournalMoodPulse.cansada:
        return Icons.cloud_rounded;
      case JournalMoodPulse.abrumada:
        return Icons.waves_rounded;
    }
  }

  Color _iconColorForPulse(JournalMoodPulse pulse, bool isSelected) {
    switch (pulse) {
      case JournalMoodPulse.agradecida:
        return const Color(0xFF8B792A);
      case JournalMoodPulse.enCalma:
        return const Color(0xFFD66885); // Flor rosa
      case JournalMoodPulse.reflexiva:
        return MindColors.estudioTrabajoAccent;
      case JournalMoodPulse.cansada:
        return Colors.grey.shade600;
      case JournalMoodPulse.abrumada:
        return const Color(0xFF2979FF);
    }
  }

  Color _circleBgForPulse(JournalMoodPulse pulse, bool isSelected) {
    switch (pulse) {
      case JournalMoodPulse.agradecida:
        return const Color(0xFFE5EFE6);
      case JournalMoodPulse.enCalma:
        return Colors.white;
      case JournalMoodPulse.reflexiva:
        return MindColors.estudioTrabajo;
      case JournalMoodPulse.cansada:
        return Colors.grey.shade100;
      case JournalMoodPulse.abrumada:
        return const Color(0xFFFFEBEE);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Cabecera de la tarjeta
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '¿Cómo late tu corazón\nhoy?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: MindColors.textPrimary,
                ),
              ),
              Text(
                'Sintoniza tu\nsentir',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: MindColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Fila de 5 opciones de pulso emocional
          Row(
            children: JournalMoodPulse.values.map((pulse) {
              final isSelected = pulse == selectedPulse;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onPulseSelected(pulse),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MindColors.bienestarPill
                          : const Color(0xFFFBF9F4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? MindColors.primary
                            : Colors.grey.shade200,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _circleBgForPulse(pulse, isSelected),
                          ),
                          child: Icon(
                            _iconForPulse(pulse),
                            size: 18,
                            color: _iconColorForPulse(pulse, isSelected),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          pulse.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? MindColors.primaryDark
                                : MindColors.textSecondary,
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
}

