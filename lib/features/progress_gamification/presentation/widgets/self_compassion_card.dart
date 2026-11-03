import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Tarjeta de recordatorio de autocompasión que reafirma que el progreso no es lineal (Principio III).
class SelfCompassionCard extends StatelessWidget {
  const SelfCompassionCard({
    super.key,
    required this.quote,
    required this.subtitle,
  });

  final String quote;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFE6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5DFD3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFD6EADA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.wb_sunny_outlined,
              size: 22,
              color: Color(0xFF386B5A),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote,
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                    color: MindColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D8572),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

