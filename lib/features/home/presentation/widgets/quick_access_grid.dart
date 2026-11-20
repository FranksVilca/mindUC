import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_radii.dart';
import '../../../../core/theme/mind_typography.dart';
import '../../domain/entities/quick_access_item.dart';

/// Cuadrícula 2x2 "Espacios para ti" con esquinas de 22dp y fondos pastel según Figma.
class QuickAccessGrid extends StatelessWidget {
  final List<QuickAccessItem> items;
  final ValueChanged<QuickAccessItem> onItemTapped;

  const QuickAccessGrid({
    super.key,
    required this.items,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Espacios para ti',
                style: MindTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: MindColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Explora tu bienestar',
              style: MindTypography.labelSmall.copyWith(
                color: MindColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Layout simétrico de 2 filas x 2 columnas sin desbordamiento
        Row(
          children: [
            if (items.isNotEmpty) Expanded(child: _buildCard(items[0])),
            const SizedBox(width: 14),
            if (items.length > 1) Expanded(child: _buildCard(items[1])),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            if (items.length > 2) Expanded(child: _buildCard(items[2])),
            const SizedBox(width: 14),
            if (items.length > 3) Expanded(child: _buildCard(items[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(QuickAccessItem item) {
    return GestureDetector(
      onTap: () => onItemTapped(item),
      child: Container(
        constraints: const BoxConstraints(minHeight: 148),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: item.backgroundColor,
          borderRadius: MindRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Fila superior: Icono circular blanco y flecha indicadora
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    size: 22,
                    color: MindColors.textPrimary,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: MindColors.textSecondary.withValues(alpha: 0.6),
                ),
              ],
            ),

            // Título y subtítulo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: MindTypography.titleMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: MindColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: MindTypography.bodyMedium.copyWith(
                    fontSize: 12,
                    color: MindColors.textSecondary,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

