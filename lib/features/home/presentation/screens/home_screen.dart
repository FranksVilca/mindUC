import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/notifications/notification_tray_modal.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';
import 'package:minduc/features/profile/presentation/controllers/profile_controller.dart';
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
              avatarUrl: ref.watch(profileControllerProvider.select((s) => s.user.avatarUrl)),
              onNotificationPressed: () => NotificationTrayModal.show(context),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                    const SizedBox(height: 18),

                    // Tarjeta de acompañamiento empático: Psicólogo IA
                    const _AiPsychologistCard(),
                    const SizedBox(height: 22),

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

/// Tarjeta de acceso rápido al Psicólogo IA optimizada como widget inmutable (const).
class _AiPsychologistCard extends StatelessWidget {
  const _AiPsychologistCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(AppRoutes.aiAssistant),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEBF5EE), Color(0xFFF3FAF5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFC7E2CF),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: MindColors.primaryDark,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MenteCalma · Psicólogo IA',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: MindColors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Escucha activa, técnicas TCC y orientación 24/7.',
                      style: TextStyle(
                        fontSize: 12,
                        color: MindColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: MindColors.primaryDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
