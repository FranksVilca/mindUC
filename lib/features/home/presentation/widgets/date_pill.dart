import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';

/// Píldora botánica con icono de calendario y fecha en español según Figma.
class DatePill extends StatelessWidget {
  final String formattedDate;

  const DatePill({
    super.key,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: MindColors.autocuidado,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 15,
            color: MindColors.primaryDark,
          ),
          const SizedBox(width: 8),
          Text(
            formattedDate,
            style: MindTypography.labelSmall.copyWith(
              color: MindColors.primaryDark,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
