import 'package:flutter/material.dart';
import 'package:minduc/core/theme/mind_colors.dart';
import 'package:minduc/features/breathing/domain/entities/breathing_technique.dart';

/// Fila superior de selección de técnica de respiración y contador de ciclos.
class TechniqueSelectorRow extends StatelessWidget {
  final BreathingTechnique currentTechnique;
  final int currentCycle;
  final int totalCycles;
  final ValueChanged<BreathingTechnique> onTechniqueChanged;

  const TechniqueSelectorRow({
    super.key,
    required this.currentTechnique,
    required this.currentCycle,
    required this.totalCycles,
    required this.onTechniqueChanged,
  });

  void _showTechniquePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: MindColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Técnicas de respiración',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MindColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Elige la técnica según tu necesidad de enfoque o calma:',
                  style: TextStyle(
                    fontSize: 13,
                    color: MindColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ...BreathingTechnique.presets.map((technique) {
                  final isSelected = technique.id == currentTechnique.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: isSelected ? MindColors.autocuidado : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? MindColors.primaryDark : MindColors.divider,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Text(
                          technique.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: MindColors.textPrimary,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            technique.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: MindColors.textSecondary,
                            ),
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: MindColors.primaryDark)
                            : null,
                        onTap: () {
                          Navigator.pop(ctx);
                          onTechniqueChanged(technique);
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cycleText = totalCycles > 0
        ? 'Ciclo $currentCycle de $totalCycles'
        : 'Ciclo $currentCycle';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. Selector desplegable de técnica (flexible y con elipsis para evitar desbordamiento)
        Flexible(
          child: Material(
            color: MindColors.autocuidado,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showTechniquePicker(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.air,
                      size: 16,
                      color: MindColors.primaryDark,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        currentTechnique.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: MindColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: MindColors.primaryDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 2. Píldora de contador de ciclos (compacta y protegida contra desbordes)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: MindColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: MindColors.divider,
              width: 1,
            ),
          ),
          child: Text(
            cycleText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: MindColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
