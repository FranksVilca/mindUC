import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/agenda/presentation/screens/agenda_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/wellness/presentation/screens/wellness_screen.dart';
import '../design_system/navigation/main_shell_screen.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _wellnessNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'wellness');
final GlobalKey<NavigatorState> _agendaNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'agenda');
final GlobalKey<NavigatorState> _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

/// Enrutador declarativo oficial de mindUC con StatefulShellRoute para 4 pestañas persistentes.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
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

