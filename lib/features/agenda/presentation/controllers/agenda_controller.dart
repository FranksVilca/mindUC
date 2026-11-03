import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/local_agenda_repository_impl.dart';
import '../../domain/entities/agenda_activity.dart';
import '../../domain/entities/agenda_category.dart';
import '../../domain/entities/agenda_state.dart';
import '../../domain/repositories/agenda_repository.dart';

/// Proveedor del repositorio de agenda bajo Clean Architecture
final agendaRepositoryProvider = Provider<AgendaRepository>((ref) {
  return LocalAgendaRepositoryImpl();
});

/// Proveedor del controlador reactivo de la agenda
final agendaControllerProvider =
    StateNotifierProvider<AgendaNotifier, AgendaState>((ref) {
  final repository = ref.watch(agendaRepositoryProvider);
  return AgendaNotifier(repository: repository);
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
  });
  Future<void> deleteActivity(String id);
}

/// Controlador reactivo StateNotifier de la agenda consciente
class AgendaNotifier extends StateNotifier<AgendaState>
    implements IAgendaController {
  AgendaNotifier({
    required this.repository,
    DateTime? initialDate,
  }) : super(
          AgendaState(
            selectedDate: initialDate ?? DateTime(2024, 10, 24),
            isLoading: true,
          ),
        ) {
    _loadActivities();
  }

  final AgendaRepository repository;

  Future<void> _loadActivities() async {
    final activities = await repository.getActivities();
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
    await repository.toggleActivityCompletion(id);
    final activities = await repository.getActivities();
    state = state.copyWith(allActivities: activities);
  }

  @override
  Future<void> createActivity({
    required String title,
    required String subtitle,
    required DateTime scheduledDateTime,
    required AgendaCategory category,
  }) async {
    final newActivity = AgendaActivity(
      id: 'activity-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: subtitle,
      scheduledDateTime: scheduledDateTime,
      category: category,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    await repository.saveActivity(newActivity);
    final activities = await repository.getActivities();
    state = state.copyWith(allActivities: activities);
  }

  @override
  Future<void> deleteActivity(String id) async {
    await repository.deleteActivity(id);
    final activities = await repository.getActivities();
    state = state.copyWith(allActivities: activities);
  }
}

