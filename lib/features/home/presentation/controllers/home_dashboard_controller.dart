import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/datasources/fake_mood_datasource.dart';
import '../../data/repositories/mood_repository_impl.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/mood_type.dart';
import '../../domain/entities/quick_access_item.dart';
import '../../domain/repositories/mood_repository.dart';
import '../../domain/usecases/record_mood_usecase.dart';
import 'home_dashboard_state.dart';

/// Proveedor del repositorio de estado de ánimo.
final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepositoryImpl(fakeDataSource: FakeMoodDataSource());
});

/// Proveedor del caso de uso de consulta de ánimo de hoy.
final getTodayMoodUseCaseProvider = Provider<GetTodayMoodUseCase>((ref) {
  final repo = ref.watch(moodRepositoryProvider);
  return GetTodayMoodUseCase(repo);
});

/// Proveedor del caso de uso de registro de ánimo.
final recordMoodUseCaseProvider = Provider<RecordMoodUseCase>((ref) {
  final repo = ref.watch(moodRepositoryProvider);
  return RecordMoodUseCase(repo);
});

/// Proveedor del controlador reactivo del dashboard de inicio.
final homeDashboardControllerProvider =
    StateNotifierProvider<HomeDashboardNotifier, HomeDashboardState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final getTodayMood = ref.watch(getTodayMoodUseCaseProvider);
  final recordMood = ref.watch(recordMoodUseCaseProvider);

  return HomeDashboardNotifier(
    authRepo: authRepo,
    getTodayMoodUseCase: getTodayMood,
    recordMoodUseCase: recordMood,
  );
});

/// Controlador del Dashboard de inicio de mindUC.
class HomeDashboardNotifier extends StateNotifier<HomeDashboardState> {
  final AuthRepository _authRepo;
  final GetTodayMoodUseCase _getTodayMoodUseCase;
  final RecordMoodUseCase _recordMoodUseCase;

  HomeDashboardNotifier({
    required AuthRepository authRepo,
    required GetTodayMoodUseCase getTodayMoodUseCase,
    required RecordMoodUseCase recordMoodUseCase,
  })  : _authRepo = authRepo,
        _getTodayMoodUseCase = getTodayMoodUseCase,
        _recordMoodUseCase = recordMoodUseCase,
        super(HomeDashboardState(
          summary: DashboardSummary(
            greetingName: _resolveGreetingName(authRepo.currentUser),
            formattedDate: SpanishDateFormatter.format(DateTime.now()),
            pendingActivitiesCount: 4,
            streakDays: 7,
          ),
          quickAccessItems: _defaultQuickAccessItems,
        )) {
    loadDashboard();
  }

  static String _resolveGreetingName(UserEntity? user) {
    final name = user?.displayName;
    if (name == null || name.trim().isEmpty) {
      return 'Estudiante';
    }
    return name.trim().split(' ').first;
  }

  static const List<QuickAccessItem> _defaultQuickAccessItems = [
    QuickAccessItem(
      id: 'relaxation',
      title: 'Relajación',
      subtitle: 'Respira y libera tensión (10 min)',
      icon: Icons.self_improvement_rounded,
      backgroundColor: MindColors.autocuidado,
      targetRoute: AppRoutes.breathingSession,
    ),
    QuickAccessItem(
      id: 'agenda',
      title: 'Agenda',
      subtitle: '4 actividades pendientes hoy',
      icon: Icons.calendar_month_rounded,
      backgroundColor: MindColors.productividad,
      targetRoute: AppRoutes.agenda,
    ),
    QuickAccessItem(
      id: 'community',
      title: 'Comunidad',
      subtitle: 'Conecta en el foro anónimo UC',
      icon: Icons.groups_rounded,
      backgroundColor: MindColors.saludMental,
      targetRoute: AppRoutes.community,
    ),
    QuickAccessItem(
      id: 'progress',
      title: 'Mi progreso',
      subtitle: 'Racha de 7 días continuos',
      icon: Icons.show_chart_rounded,
      backgroundColor: MindColors.accentCalm,
      targetRoute: AppRoutes.progress,
    ),
  ];

  Future<void> loadDashboard() async {
    final user = _authRepo.currentUser;
    final now = DateTime.now();
    final dateString = SpanishDateFormatter.toIsoDateString(now);

    final greeting = _resolveGreetingName(user);
    final formattedDate = SpanishDateFormatter.format(now);

    if (user != null) {
      final result = await _getTodayMoodUseCase(userId: user.id, dateString: dateString);
      result.when(
        onSuccess: (entry) {
          state = state.copyWith(
            selectedMood: entry?.mood,
            summary: state.summary.copyWith(
              greetingName: greeting,
              formattedDate: formattedDate,
              todayMood: entry?.mood,
            ),
          );
        },
        onFailure: (failure) {
          state = state.copyWith(errorMessage: failure.message);
        },
      );
    } else {
      state = state.copyWith(
        summary: state.summary.copyWith(
          greetingName: greeting,
          formattedDate: formattedDate,
        ),
      );
    }
  }

  Future<bool> selectMood(MoodType mood) async {
    final user = _authRepo.currentUser;
    final userId = user?.id ?? 'guest_user';
    final dateString = SpanishDateFormatter.toIsoDateString(DateTime.now());

    // Actualización optimista inmediata
    state = state.copyWith(
      selectedMood: mood,
      isSavingMood: true,
      clearError: true,
      summary: state.summary.copyWith(todayMood: mood),
    );

    final result = await _recordMoodUseCase(
      userId: userId,
      dateString: dateString,
      mood: mood,
    );

    return result.when(
      onSuccess: (entry) {
        state = state.copyWith(
          isSavingMood: false,
          selectedMood: entry.mood,
          summary: state.summary.copyWith(todayMood: entry.mood),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(
          isSavingMood: false,
          errorMessage: failure.message,
        );
        return false;
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
