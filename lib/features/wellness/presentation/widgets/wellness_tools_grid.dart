import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/wellness_tool_item.dart';

/// Cuadrícula armónica 2x2 con las 4 herramientas principales de autocuidado.
class WellnessToolsGrid extends StatelessWidget {
  final List<WellnessToolItem> tools;
  final ValueChanged<WellnessToolItem> onToolTap;

  const WellnessToolsGrid({
    super.key,
    required this.tools,
    required this.onToolTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.96,
      ),
      itemBuilder: (context, index) {
        final tool = tools[index];
        return _WellnessToolCard(
          tool: tool,
          onTap: () => onToolTap(tool),
        );
      },
    );
  }
}

class _WellnessToolCard extends StatelessWidget {
  final WellnessToolItem tool;
  final VoidCallback onTap;

  const _WellnessToolCard({
    required this.tool,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tool.backgroundColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Fila superior: Icono en caja blanca e insignia temporal/privacidad
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      tool.icon,
                      size: 22,
                      color: MindColors.primaryDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tool.badgeText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: MindColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              // Sección de texto: Título y breve subtítulo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MindColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tool.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: MindColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
