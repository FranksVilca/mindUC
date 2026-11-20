import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/agenda/presentation/screens/agenda_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/welcome_auth_screen.dart';
import '../../features/breathing/presentation/screens/breathing_screen.dart';
import '../../features/community_forum/presentation/screens/community_screen.dart';
import '../../features/focus_pomodoro/presentation/screens/pomodoro_screen.dart';
import '../../features/personal_journal/presentation/screens/journal_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/progress_gamification/presentation/screens/progress_screen.dart';
import '../../features/relaxation/presentation/screens/guided_exercise_screen.dart';
import '../../features/relaxation/presentation/screens/relaxation_screen.dart';
import '../../features/wellness/presentation/screens/psychologist_assistant_screen.dart';
import '../../features/wellness/presentation/screens/wellness_screen.dart';
import '../design_system/navigation/main_shell_screen.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _wellnessNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'wellness');
final GlobalKey<NavigatorState> _agendaNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'agenda');
final GlobalKey<NavigatorState> _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

/// Helper para notificar a GoRouter ante emisiones de un Stream (reactivo).
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Proveedor de GoRouter reactivo al estado de autenticación.
final routerProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.auth;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.auth;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Ruta de Bienvenida y Autenticación
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const WelcomeAuthScreen(),
      ),

      // Rutas de accesos rápidos
      GoRoute(
        path: AppRoutes.community,
        builder: (context, state) => const CommunityScreen(),
      ),
      GoRoute(
        path: AppRoutes.progress,
        builder: (context, state) => const ProgressScreen(),
      ),
      // Sesión guiada de respiración y relajación
      GoRoute(
        path: AppRoutes.breathingSession,
        builder: (context, state) => const BreathingScreen(),
      ),
      // Módulo dedicado de Relajación y Pausas Activas
      GoRoute(
        path: AppRoutes.relaxation,
        builder: (context, state) => const RelaxationScreen(),
      ),
      GoRoute(
        path: AppRoutes.relaxationExercise,
        builder: (context, state) => const GuidedExerciseScreen(),
      ),
      // Sesión de Concentración Pomodoro
      GoRoute(
        path: AppRoutes.pomodoroSession,
        builder: (context, state) => const PomodoroScreen(),
      ),
      // Diario personal íntimo (Espacio Sagrado)
      GoRoute(
        path: AppRoutes.journalNew,
        builder: (context, state) => const JournalScreen(),
      ),
      // Asistente Psicológico IA & Orientación Universitaria
      GoRoute(
        path: AppRoutes.aiAssistant,
        builder: (context, state) => const PsychologistAssistantScreen(),
      ),

      // Shell persistente de 4 pestañas
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Pestaña 0: Inicio
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Pestaña 1: Bienestar
          StatefulShellBranch(
            navigatorKey: _wellnessNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.wellness,
                builder: (context, state) => const WellnessScreen(),
              ),
            ],
          ),

          // Pestaña 2: Agenda
          StatefulShellBranch(
            navigatorKey: _agendaNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.agenda,
                builder: (context, state) => const AgendaScreen(),
              ),
            ],
          ),

          // Pestaña 3: Perfil
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
