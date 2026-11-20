import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/agenda_repository_impl.dart';
import '../../domain/entities/agenda_activity.dart';
import '../../domain/entities/agenda_category.dart';
import '../../domain/entities/agenda_state.dart';
import '../../domain/repositories/agenda_repository.dart';

/// Proveedor del repositorio de agenda bajo Clean Architecture
final agendaRepositoryProvider = Provider<AgendaRepository>((ref) {
  return AgendaRepositoryImpl();
});

/// Proveedor del controlador reactivo de la agenda
final agendaControllerProvider =
    StateNotifierProvider<AgendaNotifier, AgendaState>((ref) {
  final repository = ref.watch(agendaRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);
  final userId = currentUser?.id ?? '';
  return AgendaNotifier(
    repository: repository,
    userId: userId,
  );
});

/// Interfaz del controlador de la agenda
abstract class IAgendaController {
  void selectDate(DateTime date);
  void selectFilter(String filter);
  Future<void> toggleActivityCompletion(String id);
  Future<void> createActivity({
    required String title,
    required String subtitle,
    required DateTime scheduledDateTime,
    required AgendaCategory category,
    int? reminderMinutesBefore,
    List<int>? reminderMinutesList,
  });
  Future<void> updateActivity({
    required String id,
    required String title,
    required String subtitle,
    required DateTime scheduledDateTime,
    required AgendaCategory category,
    int? reminderMinutesBefore,
    List<int>? reminderMinutesList,
  });
  Future<void> deleteActivity(String id);
}

/// Controlador reactivo StateNotifier de la agenda consciente
class AgendaNotifier extends StateNotifier<AgendaState>
    implements IAgendaController {
  AgendaNotifier({
    required this.repository,
    this.userId = '',
    DateTime? initialDate,
  }) : super(
          AgendaState(
            selectedDate: initialDate ?? DateTime.now(),
            isLoading: true,
          ),
        ) {
      _loadActivities();
  }

  final AgendaRepository repository;
  final String userId;

  Future<void> _loadActivities() async {
    final activities = await repository.getActivities(userId);
    state = state.copyWith(
      allActivities: activities,
      isLoading: false,
    );
  }

  @override
  void selectDate(DateTime date) {
    state = state.copyWith(
      selectedDate: DateTime(date.year, date.month, date.day),
    );
  }

  @override
  void selectFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  @override
  Future<void> toggleActivityCompletion(String id) async {
    final existing = state.allActivities.where((a) => a.id == id).toList();
    if (existing.isNotEmpty && !existing.first.isCompleted) {
      await NotificationService.instance.cancelAgendaActivityReminders(id);
    } else if (existing.isNotEmpty && existing.first.isCompleted) {
      // Re-programar alarmas si se desmarca y el evento aún no ha pasado
      final act = existing.first;
      final reminders = act.reminderMinutesList.isNotEmpty
          ? act.reminderMinutesList
          : (act.reminderMinutesBefore != null
              ? [act.reminderMinutesBefore!]
              : const <int>[]);
      if (reminders.isNotEmpty) {
        await NotificationService.instance.scheduleAgendaActivityReminders(
          activityId: id,
          title: act.title,
          scheduledDateTime: act.scheduledDateTime,
          reminderMinutesList: reminders,
        );
      }
    }
    await repository.toggleActivityCompletion(id, userId);
    final activities = await repository.getActivities(userId);
    state = state.copyWith(allActivities: activities);
  }

  @override
  Future<void> createActivity({
    required String title,
    required String subtitle,
    required DateTime scheduledDateTime,
    required AgendaCategory category,
    int? reminderMinutesBefore,
    List<int>? reminderMinutesList,
  }) async {
    final reminders = reminderMinutesList ??
        (reminderMinutesBefore != null ? [reminderMinutesBefore] : const <int>[]);

    final newActivity = AgendaActivity(
      id: 'activity-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: title,
      subtitle: subtitle,
      scheduledDateTime: scheduledDateTime,
      category: category,
      reminderMinutesBefore: reminders.firstOrNull,
      reminderMinutesList: reminders,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    await repository.saveActivity(newActivity);
    if (reminders.isNotEmpty) {
      await NotificationService.instance.scheduleAgendaActivityReminders(
        activityId: newActivity.id,
        title: title,
        scheduledDateTime: scheduledDateTime,
        reminderMinutesList: reminders,
      );
    }
    final activities = await repository.getActivities(userId);
    state = state.copyWith(allActivities: activities);
  }

  @override
  Future<void> updateActivity({
    required String id,
    required String title,
    required String subtitle,
    required DateTime scheduledDateTime,
    required AgendaCategory category,
    int? reminderMinutesBefore,
    List<int>? reminderMinutesList,
  }) async {
    final reminders = reminderMinutesList ??
        (reminderMinutesBefore != null ? [reminderMinutesBefore] : const <int>[]);

    final existing = state.allActivities.firstWhere(
      (a) => a.id == id,
      orElse: () => AgendaActivity(
        id: id,
        userId: userId,
        title: title,
        subtitle: subtitle,
        scheduledDateTime: scheduledDateTime,
        category: category,
        reminderMinutesBefore: reminders.firstOrNull,
        reminderMinutesList: reminders,
        createdAt: DateTime.now(),
      ),
    );

    final updated = existing.copyWith(
      title: title,
      subtitle: subtitle,
      scheduledDateTime: scheduledDateTime,
      category: category,
      reminderMinutesBefore: reminders.firstOrNull,
      reminderMinutesList: reminders,
    );

    await repository.saveActivity(updated);

    await NotificationService.instance.cancelAgendaActivityReminders(id);
    if (reminders.isNotEmpty) {
      await NotificationService.instance.scheduleAgendaActivityReminders(
        activityId: id,
        title: title,
        scheduledDateTime: scheduledDateTime,
        reminderMinutesList: reminders,
      );
    }

    final activities = await repository.getActivities(userId);
    state = state.copyWith(allActivities: activities);
  }

  @override
  Future<void> deleteActivity(String id) async {
    await NotificationService.instance.cancelAgendaActivityReminders(id);
    await repository.deleteActivity(id, userId);
    final activities = await repository.getActivities(userId);
    state = state.copyWith(allActivities: activities);
  }
}
