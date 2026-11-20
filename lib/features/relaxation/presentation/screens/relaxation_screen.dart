import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/avatars/mind_user_avatar.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import '../controllers/relaxation_controller.dart';
import '../widgets/activity_card.dart';
import '../widgets/relaxation_hero_banner.dart';

/// Pantalla principal oficial del Módulo de Relajación y Pausas Activas de mindUC.
class RelaxationScreen extends ConsumerStatefulWidget {
  const RelaxationScreen({super.key});

  @override
  ConsumerState<RelaxationScreen> createState() => _RelaxationScreenState();
}

class _RelaxationScreenState extends ConsumerState<RelaxationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(relaxationControllerProvider.notifier).loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(relaxationControllerProvider);
    final notifier = ref.read(relaxationControllerProvider.notifier);

    return Scaffold(
      backgroundColor: MindColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 84,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                key: const Key('relaxation_back_button'),
                icon: const Icon(Icons.arrow_back, color: MindColors.textPrimary),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.home);
                  }
                },
              ),
            ),
            const MindAppLogo(size: 28),
          ],
        ),
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              Text(
                'mindUC',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MindColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Relajación y Pausas Activas',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: MindColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: MindUserAvatar(
                avatarId: null,
                size: 32,
                onTap: () => context.push(AppRoutes.profile),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => notifier.loadActivities(),
          color: MindColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Banner superior motivacional y métricas del día
                RelaxationHeroBanner(
                  completedCount: state.completedActivitiesCountToday,
                  totalCount: state.activities.length,
                  reliefMinutes: state.totalReliefMinutesToday,
                ),

                const SizedBox(height: 24),

                // 2. Encabezado de sección
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rutinas guiadas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: MindColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Libre elección',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: MindColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Elige libremente cualquier pausa en cualquier momento según tu necesidad. No es necesario seguir un orden específico.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: MindColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Listado de tarjetas de actividades
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.activities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final activity = state.activities[index];
                    return ActivityCard(
                      activity: activity,
                      onStart: () {
                        notifier.startActivity(activity.id);
                        context.push(AppRoutes.relaxationExercise);
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
