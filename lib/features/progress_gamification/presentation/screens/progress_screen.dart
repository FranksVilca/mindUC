import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import 'package:minduc/features/profile/presentation/controllers/profile_controller.dart';
import '../controllers/progress_controller.dart';
import '../widgets/achievements_garden.dart';
import '../widgets/active_streak_card.dart';
import '../widgets/growth_badge_title.dart';
import '../widgets/progress_header.dart';
import '../widgets/self_compassion_card.dart';
import '../widgets/weekly_intentions_card.dart';
import '../widgets/weekly_pause_grid.dart';

/// Pantalla principal de "Mi Progreso & Florecimiento" (Gamificación Detallada).
/// Diseñada bajo el Principio III de la Constitución: Métricas Compasivas sin Ansiedad.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressControllerProvider);
    final notifier = ref.read(progressControllerProvider.notifier);

    return Scaffold(
      backgroundColor: MindColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera superior serena con retorno
            ProgressHeader(
              avatarUrl: ref.watch(profileControllerProvider.select((s) => s.user.avatarUrl)),
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.home);
                }
              },
              onProfile: () => context.go(AppRoutes.profile),
            ),

            // Contenido desplazable continuo
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Insignia y título principal
                    const GrowthBadgeTitle(),

                    // Tarjeta de racha de autocuidado activo (7 días)
                    ActiveStreakCard(streak: state.streak),

                    // Momentos de pausa semanales (2x2)
                    WeeklyPauseGrid(metrics: state.metrics),

                    // Jardín de logros botánicos (3 de 4)
                    AchievementsGarden(
                      achievements: state.achievements,
                      bloomedCount: state.bloomedCount,
                      totalCount: state.totalAchievements,
                    ),

                    // Intenciones amables semanales con avance interactivo
                    WeeklyIntentionsCard(
                      intentions: state.intentions,
                      onToggleIntention: notifier.toggleIntention,
                    ),

                    // Tarjeta de recordatorio de autocompasión
                    SelfCompassionCard(
                      quote: state.quote,
                      subtitle: state.quoteSubtitle,
                    ),

                    const SizedBox(height: 32),
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

