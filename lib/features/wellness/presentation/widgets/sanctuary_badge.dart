import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Píldora botánica superior `🌱 SANCTUARY MODE` según el mockup de Figma.
class SanctuaryBadge extends StatelessWidget {
  final String label;

  const SanctuaryBadge({
    super.key,
    this.label = 'SANCTUARY MODE',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MindColors.autocuidado,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: MindColors.primaryLight.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.spa,
            size: 14,
            color: MindColors.primaryDark,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: MindColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
