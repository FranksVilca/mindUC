import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Modal compasivo para seleccionar preferencias de bienestar (sonido o técnica de respiración).
class PreferenceSelectionModal extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onSelected;

  const PreferenceSelectionModal({
    super.key,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  /// Muestra el modal en una hoja inferior serena.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<String> options,
    required String selectedOption,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PreferenceSelectionModal(
        title: title,
        subtitle: subtitle,
        options: options,
        selectedOption: selectedOption,
        onSelected: (val) {
          onSelected(val);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Asa superior
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Título
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: MindColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4.0),

            // Subtítulo
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13.5,
                color: MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16.0),

            // Lista de opciones
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Color(0xFFF0F0F0),
                ),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == selectedOption;

                  return InkWell(
                    onTap: () => onSelected(option),
                    borderRadius: BorderRadius.circular(12.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? const Color(0xFF2C5E47)
                                    : MindColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF2C5E47),
                              size: 20.0,
                            )
                          else
                            Icon(
                              Icons.circle_outlined,
                              color: Colors.grey.shade300,
                              size: 20.0,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}

