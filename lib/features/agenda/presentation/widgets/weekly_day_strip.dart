import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/agenda_activity.dart';

/// Selector semanal interactivo horizontal (Lunes a Domingo) con indicadores de actividad.
class WeeklyDayStrip extends StatelessWidget {
  const WeeklyDayStrip({
    super.key,
    required this.selectedDate,
    required this.activities,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final List<AgendaActivity> activities;
  final ValueChanged<DateTime> onDateSelected;

  static const List<String> _weekDayNames = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];

  @override
  Widget build(BuildContext context) {
    // Calcular Lunes a Domingo de la semana de selectedDate
    final weekday = selectedDate.weekday; // 1 (Lun) .. 7 (Dom)
    final monday = selectedDate.subtract(Duration(days: weekday - 1));

    final days = List.generate(7, (index) {
      final d = monday.add(Duration(days: index));
      return DateTime(d.year, d.month, d.day);
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        final isSelected = day.year == selectedDate.year &&
            day.month == selectedDate.month &&
            day.day == selectedDate.day;

        // Conteo de actividades del día para los puntos de densidad
        final dayActivityCount = activities.where((a) {
          final s = a.scheduledDateTime;
          return s.year == day.year && s.month == day.month && s.day == day.day;
        }).length;

        final dayAbbr = _weekDayNames[day.weekday - 1];

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: InkWell(
              onTap: () => onDateSelected(day),
              borderRadius: BorderRadius.circular(22),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFC7E2D3)
                      : const Color(0xFFF3EFEA),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6DAA8A)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dayAbbr,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? MindColors.textPrimary
                            : MindColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? MindColors.textPrimary
                            : const Color(0xFF4A4441),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Puntos indicadores de densidad de tareas
                    SizedBox(
                      height: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (dayActivityCount == 1) ...[
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3B5648)
                                    : Colors.grey.shade400,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ] else if (dayActivityCount >= 2) ...[
                            Container(
                              width: 3.5,
                              height: 3.5,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3B5648)
                                    : Colors.grey.shade400,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 2.5),
                            Container(
                              width: 3.5,
                              height: 3.5,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3B5648)
                                    : Colors.grey.shade400,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ] else ...[
                            const SizedBox(width: 4),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

