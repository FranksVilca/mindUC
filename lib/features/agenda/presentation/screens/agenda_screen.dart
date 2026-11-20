import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/notifications/notification_tray_modal.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/voice/speech_recognition_service.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import 'package:minduc/features/profile/presentation/controllers/profile_controller.dart';
import '../controllers/agenda_controller.dart';
import '../widgets/activity_card.dart';
import '../widgets/activity_create_modal.dart';
import '../widgets/agenda_header.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/rhythm_balance_card.dart';
import '../widgets/voice_assistant_modal.dart';
import '../widgets/weekly_day_strip.dart';

/// Pantalla principal de "Mi Agenda consciente" (Pestaña 2 del Shell).
class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(agendaControllerProvider);
    final notifier = ref.read(agendaControllerProvider.notifier);
    final speechService = ref.watch(speechRecognitionServiceProvider);

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
            tooltip: 'Registrar actividad por voz',
            onPressed: () {
              VoiceAssistantModal.show(
                context,
                speechService: speechService,
                referenceDate: state.selectedDate,
                onActivityParsed: (parsed) {
                    ActivityCreateModal.show(
                      context,
                      defaultDate: parsed.scheduledDate,
                      initialTitle: parsed.title,
                      initialSubtitle: parsed.subtitle,
                      initialCategory: parsed.category,
                      initialTime: parsed.scheduledTime,
                      speechService: speechService,
                      onSave: (title, subtitle, scheduledDateTime, category, reminderMinutesBefore, reminderMinutesList) async {
                        try {
                          await notifier.createActivity(
                            title: title,
                            subtitle: subtitle,
                            scheduledDateTime: scheduledDateTime,
                            category: category,
                            reminderMinutesBefore: reminderMinutesBefore,
                            reminderMinutesList: reminderMinutesList,
                          );
                          notifier.selectDate(scheduledDateTime);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Actividad guardada correctamente 🌿'),
                                backgroundColor: Color(0xFF2E6347),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al guardar: $e'),
                                backgroundColor: Colors.red.shade700,
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
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
                  speechService: speechService,
                  onSave: (title, subtitle, scheduledDateTime, category, reminderMinutesBefore, reminderMinutesList) async {
                    try {
                      await notifier.createActivity(
                        title: title,
                        subtitle: subtitle,
                        scheduledDateTime: scheduledDateTime,
                        category: category,
                        reminderMinutesBefore: reminderMinutesBefore,
                        reminderMinutesList: reminderMinutesList,
                      );
                      notifier.selectDate(scheduledDateTime);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Actividad guardada correctamente 🌿'),
                            backgroundColor: Color(0xFF2E6347),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al guardar: $e'),
                            backgroundColor: Colors.red.shade700,
                          ),
                        );
                      }
                    }
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
            AgendaHeader(
              avatarUrl: ref.watch(profileControllerProvider.select((s) => s.user.avatarUrl)),
              onProfile: () => context.go(AppRoutes.profile),
              onNotification: () => NotificationTrayModal.show(context),
            ),

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
                    const SizedBox(height: 10),

                    // Barra de navegación temporal entre semanas y fechas
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateHeader,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: MindColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Semana ${state.weekNumber}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: MindColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Botón "Hoy"
                        InkWell(
                          key: const Key('agenda_today_button'),
                          onTap: () => notifier.selectDate(DateTime.now()),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5EFE9),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFC3DEC8),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              'Hoy',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2C4C3B),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Botón Retroceder semana
                        IconButton(
                          key: const Key('agenda_prev_week_button'),
                          icon: const Icon(Icons.chevron_left_rounded, size: 22),
                          color: MindColors.textPrimary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          tooltip: 'Semana anterior',
                          onPressed: () {
                            notifier.selectDate(
                              state.selectedDate.subtract(const Duration(days: 7)),
                            );
                          },
                        ),
                        // Botón Avanzar semana
                        IconButton(
                          key: const Key('agenda_next_week_button'),
                          icon: const Icon(Icons.chevron_right_rounded, size: 22),
                          color: MindColors.textPrimary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          tooltip: 'Semana siguiente',
                          onPressed: () {
                            notifier.selectDate(
                              state.selectedDate.add(const Duration(days: 7)),
                            );
                          },
                        ),
                        // Botón Calendario para seleccionar cualquier fecha
                        IconButton(
                          key: const Key('agenda_calendar_picker_button'),
                          icon: const Icon(Icons.calendar_month_rounded, size: 20),
                          color: MindColors.primaryDark,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                          tooltip: 'Seleccionar fecha en calendario',
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: state.selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2035),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: MindColors.primaryDark,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: MindColors.textPrimary,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              notifier.selectDate(picked);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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
                          'Presiona "+ Nueva" o usa el micrófono para planificar una actividad.',
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
                            key: ValueKey(activity.id),
                            activity: activity,
                            onToggleComplete: () {
                              notifier.toggleActivityCompletion(activity.id);
                            },
                            onEdit: () {
                              ActivityCreateModal.show(
                                context,
                                defaultDate: activity.scheduledDateTime,
                                activityToEdit: activity,
                                speechService: speechService,
                                onSave: (_, __, ___, ____, _____, ______) {},
                                onUpdate: (id, title, subtitle, scheduledDateTime, category, reminderMinutesBefore, reminderMinutesList) async {
                                  try {
                                    await notifier.updateActivity(
                                      id: id,
                                      title: title,
                                      subtitle: subtitle,
                                      scheduledDateTime: scheduledDateTime,
                                      category: category,
                                      reminderMinutesBefore: reminderMinutesBefore,
                                      reminderMinutesList: reminderMinutesList,
                                    );
                                    notifier.selectDate(scheduledDateTime);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Actividad actualizada correctamente 🌿'),
                                          backgroundColor: Color(0xFF2E6347),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error al actualizar: $e'),
                                          backgroundColor: Colors.red.shade700,
                                        ),
                                      );
                                    }
                                  }
                                },
                                onDelete: (id) async {
                                  try {
                                    await notifier.deleteActivity(id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Actividad eliminada 🌿'),
                                          backgroundColor: Color(0xFF385C4B),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error al eliminar: $e'),
                                          backgroundColor: Colors.red.shade700,
                                        ),
                                      );
                                    }
                                  }
                                },
                              );
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
