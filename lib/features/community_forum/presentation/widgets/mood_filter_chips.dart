import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/community_mood_category.dart';

/// Selector horizontal de filtros por sentir con conteo de hilos activos.
class MoodFilterChips extends StatelessWidget {
  const MoodFilterChips({
    super.key,
    required this.selectedFilter,
    required this.activeThreadCount,
    required this.onFilterSelected,
  });

  final CommunityMoodCategory selectedFilter;
  final int activeThreadCount;
  final ValueChanged<CommunityMoodCategory> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado: "Filtrar por sentir" y conteo de hilos activos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtrar por sentir',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: MindColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                '$activeThreadCount hilos activos',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5D8572),
                ),
              ),
            ],
          ),
        ),

        // Lista horizontal de chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: CommunityMoodCategory.values.map((category) {
              final isSelected = category == selectedFilter;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => onFilterSelected(category),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF3F5E4D)
                          : MindColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF3F5E4D)
                            : MindColors.divider,
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF3F5E4D).withAlpha(35),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      category.displayName,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : MindColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
