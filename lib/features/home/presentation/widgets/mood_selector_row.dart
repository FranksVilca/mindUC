import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';
import '../../domain/entities/mood_type.dart';

/// Selector interactivo de estado de ánimo en 1 solo toque según Figma.
class MoodSelectorRow extends StatelessWidget {
  final MoodType? selectedMood;
  final ValueChanged<MoodType> onMoodSelected;
  final bool isSaving;

  const MoodSelectorRow({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila de encabezado
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tu estado de ánimo',
              style: MindTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: MindColors.textPrimary,
              ),
            ),
            Text(
              'Selecciona uno',
              style: MindTypography.labelSmall.copyWith(
                color: MindColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Fila de 5 opciones de ánimo
        Row(
          children: MoodType.values.map((mood) {
            final isSelected = selectedMood == mood;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  onTap: isSaving ? null : () => onMoodSelected(mood),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: mood.backgroundColor,
                      borderRadius: BorderRadius.circular(16.0),
                      border: isSelected
                          ? Border.all(color: MindColors.primaryDark, width: 2.0)
                          : Border.all(color: Colors.transparent, width: 2.0),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: MindColors.primaryDark.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          mood.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          mood.label,
                          style: MindTypography.labelSmall.copyWith(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? MindColors.primaryDark : MindColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
