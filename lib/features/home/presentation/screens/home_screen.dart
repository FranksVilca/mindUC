import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';
import '../controllers/home_dashboard_controller.dart';
import '../widgets/date_pill.dart';
import '../widgets/home_header.dart';
import '../widgets/mood_selector_row.dart';
import '../widgets/quick_access_grid.dart';

/// Pantalla oficial de Inicio (Dashboard) de mindUC según Figma.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(homeDashboardControllerProvider);
    final notifier = ref.read(homeDashboardControllerProvider.notifier);

    return Scaffold(
      backgroundColor: MindColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera superior con marca, campana y avatar
            HomeHeader(
              onNotificationPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sin nuevas notificaciones 🌿'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              onAvatarPressed: () {
                context.go('/profile');
              },
            ),

            // Contenido desplazable sereno
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Píldora de fecha
                    DatePill(
                      formattedDate: dashboardState.summary.formattedDate,
                    ),
                    const SizedBox(height: 16),

                    // Saludo empático con nombre de estudiante
                    Text(
                      '¡Hola, ${dashboardState.summary.greetingName}! 🌿',
                      style: MindTypography.displayLarge.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: MindColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '¿Cómo te sientes en este momento?',
                      style: MindTypography.bodyMedium.copyWith(
                        fontSize: 15,
                        color: MindColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Selector interactivo de estado de ánimo
                    MoodSelectorRow(
                      selectedMood: dashboardState.selectedMood,
                      isSaving: dashboardState.isSavingMood,
                      onMoodSelected: (mood) => notifier.selectMood(mood),
                    ),
                    const SizedBox(height: 26),

                    // Cuadrícula 2x2 "Espacios para ti"
                    QuickAccessGrid(
                      items: dashboardState.quickAccessItems,
                      onItemTapped: (item) {
                        context.go(item.targetRoute);
                      },
                    ),
                    const SizedBox(height: 24),
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
