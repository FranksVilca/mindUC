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

/// Proveedor de GoRouter reactivo al estado de autenticaciÃ³n.
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
      // Ruta de Bienvenida y AutenticaciÃ³n
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const WelcomeAuthScreen(),
      ),

      // Rutas de accesos rÃ¡pidos
      GoRoute(
        path: AppRoutes.community,
        builder: (context, state) => const CommunityScreen(),
      ),
      GoRoute(
        path: AppRoutes.progress,
        builder: (context, state) => const ProgressScreen(),
      ),
      // SesiÃ³n guiada de respiraciÃ³n y relajaciÃ³n
      GoRoute(
        path: AppRoutes.breathingSession,
        builder: (context, state) => const BreathingScreen(),
      ),
      // SesiÃ³n de ConcentraciÃ³n Pomodoro
      GoRoute(
        path: AppRoutes.pomodoroSession,
        builder: (context, state) => const PomodoroScreen(),
      ),
      // Diario personal Ã­ntimo (Espacio Sagrado)
      GoRoute(
        path: AppRoutes.journalNew,
        builder: (context, state) => const JournalScreen(),
      ),

      // Shell persistente de 4 pestaÃ±as
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // PestaÃ±a 0: Inicio
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // PestaÃ±a 1: Bienestar
          StatefulShellBranch(
            navigatorKey: _wellnessNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.wellness,
                builder: (context, state) => const WellnessScreen(),
              ),
            ],
          ),

          // PestaÃ±a 2: Agenda
          StatefulShellBranch(
            navigatorKey: _agendaNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.agenda,
                builder: (context, state) => const AgendaScreen(),
              ),
            ],
          ),

          // PestaÃ±a 3: Perfil
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
