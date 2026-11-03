import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/pomodoro_interval_type.dart';

/// Selector segmentado horizontal para alternar entre Enfoque, Corto y Largo.
class IntervalSelectorRow extends StatelessWidget {
  const IntervalSelectorRow({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final PomodoroIntervalType selectedType;
  final ValueChanged<PomodoroIntervalType> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: PomodoroIntervalType.values.map((type) {
          final isSelected = type == selectedType;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTypeSelected(type),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: isSelected
                      ? [
                          BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ).boxShadow!.first,
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSelected) ...[
                      const Icon(
                        Icons.lens_blur_rounded,
                        size: 16,
                        color: MindColors.primary,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? MindColors.textPrimary
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
    );
  }
}

