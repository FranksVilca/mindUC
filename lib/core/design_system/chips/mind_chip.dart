import 'package:flutter/material.dart';
import '../../theme/mind_colors.dart';
import '../../theme/mind_radii.dart';
import '../../theme/mind_typography.dart';

/// Etiqueta o filtro seleccionable de bienestar oficial de mindUC con dot de color opcional.
class MindChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? dotColor;
  final Color? backgroundColor;
  final IconData? icon;

  const MindChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.dotColor,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = isSelected
        ? MindColors.primary
        : (backgroundColor ?? MindColors.surface);

    final effectiveFg = isSelected ? MindColors.onPrimary : MindColors.textPrimary;

    return Material(
      color: Colors.transparent,
      borderRadius: MindRadii.chipRadius,
      child: InkWell(
        borderRadius: MindRadii.chipRadius,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: MindRadii.chipRadius,
            border: Border.all(
              color: isSelected ? MindColors.primary : MindColors.divider,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dotColor != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              if (icon != null) ...[
                Icon(icon, size: 16, color: effectiveFg),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: MindTypography.labelSmall.copyWith(
                  color: effectiveFg,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

