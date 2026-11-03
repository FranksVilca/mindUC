import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../controllers/agenda_controller.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_create_modal.dart';
import '../widgets/agenda_header.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/rhythm_balance_card.dart';
import '../widgets/weekly_day_strip.dart';

/// Pantalla principal de "Mi Agenda consciente" (Pestaña 2 del Shell).
class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agendaControllerProvider);
    final notifier = ref.read(agendaControllerProvider.notifier);

    final weekdayName =
        SpanishDateFormatter.weekdays[state.selectedDate.weekday - 1];
    final monthName =
        SpanishDateFormatter.months[state.selectedDate.month - 1];
    final dateHeader = '$weekdayName, $monthName ${state.selectedDate.year}';

    return Scaffold(
      backgroundColor: MindColors.background,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón circular de micrófono (Asistencia por voz)
          FloatingActionButton(
            heroTag: 'agenda_voice_btn',
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF3B5648),
            elevation: 3,
            shape: const CircleBorder(),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Agendador consciente por voz en preparación 🌿',
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: MindColors.primaryDark,
                ),
              );
            },
            child: const Icon(Icons.mic_none_rounded, size: 24),
          ),
          const SizedBox(width: 12),

          // Botón alargado: + Nueva
          FloatingActionButton.extended(
            heroTag: 'agenda_new_btn',
            backgroundColor: const Color(0xFFBFE3D0), // Menta suave de Figma
            foregroundColor: const Color(0xFF264132),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              ActivityCreateModal.show(
                context,
                defaultDate: state.selectedDate,
                onSave: (title, subtitle, scheduledDateTime, category) {
                  notifier.createActivity(
                    title: title,
                    subtitle: subtitle,
                    scheduledDateTime: scheduledDateTime,
                    category: category,
                  );
                },
              );
            },
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              'Nueva',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF264132),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera superior
            const AgendaHeader(),

            // Cuerpo desplazable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título principal
                    const Text(
                      'Mi Agenda consciente',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: MindColors.textPrimary,
                        letterSpacing: -0.6,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Fila de contexto temporal y semana
                    Row(
                      children: [
                        Text(
                          dateHeader,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: MindColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: MindColors.textTertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Semana ${state.weekNumber}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: MindColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tira Semanal de 7 días
                    WeeklyDayStrip(
                      selectedDate: state.selectedDate,
                      activities: state.allActivities,
                      onDateSelected: notifier.selectDate,
                    ),
                    const SizedBox(height: 20),

                    // Tarjeta de resumen de ritmo
                    RhythmBalanceCard(
                      totalActivities: state.totalForDay,
                      completedActivities: state.completedForDay,
                      onHistoryTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Historial de balance consciente disponible.',
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: MindColors.primaryDark,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    // Filtros por Categoría
                    CategoryFilterChips(
                      selectedFilter: state.selectedFilter,
                      onFilterSelected: notifier.selectFilter,
                    ),
                    const SizedBox(height: 16),

                    // Lista de actividades
                    if (state.filteredActivities.isEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Text(
                          'Día despejado para descansar o fluir a tu propio ritmo 🌿\n'
                          'Presiona "+ Nueva" para planificar un hábito o compromiso consciente.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: MindColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ] else ...[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.filteredActivities.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final activity = state.filteredActivities[index];
                          return ActivityCard(
                            activity: activity,
                            onToggleComplete: () {
                              notifier.toggleActivityCompletion(activity.id);
                            },
                            onTap: () {
                              notifier.toggleActivityCompletion(activity.id);
                            },
                          );
                        },
                      ),
                    ],

                    // Espaciador para no solapar los Floating Action Buttons
                    const SizedBox(height: 85),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
