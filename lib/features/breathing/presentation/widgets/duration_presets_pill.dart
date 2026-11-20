import 'package:flutter/material.dart';
import 'package:minduc/core/theme/mind_colors.dart';

/// Selector segmentado horizontal de duración predefinida: 3 min, 5 min, 10 min, Libre.
class DurationPresetsPill extends StatelessWidget {
  final int currentTargetSeconds;
  final ValueChanged<int> onPresetSelected;

  const DurationPresetsPill({
    super.key,
    required this.currentTargetSeconds,
    required this.onPresetSelected,
  });

  static const List<Map<String, dynamic>> _presets = [
    {'seconds': 180, 'label': '3 min'},
    {'seconds': 300, 'label': '5 min'},
    {'seconds': 600, 'label': '10 min'},
    {'seconds': 0, 'label': 'Libre'},
  ];

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: MindColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: MindColors.divider, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _presets.map((preset) {
            final int seconds = preset['seconds'] as int;
            final String label = preset['label'] as String;
            final bool isSelected = currentTargetSeconds == seconds;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Material(
                color: isSelected ? MindColors.autocuidado : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onPresetSelected(seconds),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: MindColors.primaryDark, width: 1.2)
                          : null,
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? MindColors.primaryDark : MindColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
