import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import 'package:minduc/features/profile/presentation/controllers/profile_controller.dart';
import '../controllers/wellness_controller.dart';
import '../widgets/ai_assistant_dialog.dart';
import '../widgets/sanctuary_badge.dart';
import '../widgets/suggested_exercise_card.dart';
import '../widgets/wellness_header.dart';
import '../widgets/wellness_tools_grid.dart';

/// Pantalla oficial del Hub de Bienestar de mindUC según el mockup
/// de Figma (`mindUC - Bienestar.png`).
class WellnessScreen extends ConsumerWidget {
  const WellnessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wellnessState = ref.watch(wellnessControllerProvider);
    final controller = ref.read(wellnessControllerProvider.notifier);

    return Scaffold(
      backgroundColor: MindColors.background,
      appBar: WellnessHeader(
        avatarUrl: ref.watch(profileControllerProvider.select((s) => s.user.avatarUrl)),
        onProfileTap: () => context.go(AppRoutes.profile),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Píldora botánica de modo santuario
              const SanctuaryBadge(),

              const SizedBox(height: 14),

              // 2. Título de bienvenida e inspiración serena
              const Text(
                'Tu espacio de bienestar ✨',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MindColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tómate una pausa consciente. Cada pequeño respiro renueva tu energía interior.',
                style: TextStyle(
                  fontSize: 13.5,
                  color: MindColors.textSecondary,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 20),

              // 3. Tarjeta destacada: Ejercicio sugerido del día
              SuggestedExerciseCard(
                exercise: wellnessState.suggestedExercise,
                onStart: () => controller.startSuggestedBreathing(ref, context),
              ),

              const SizedBox(height: 22),

              // 4. Cuadrícula 2x2 de herramientas de autocuidado
              WellnessToolsGrid(
                tools: wellnessState.tools,
                onToolTap: (tool) {
                  if (tool.isDeferred) {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AiAssistantComingSoonDialog(
                        onDismiss: () => Navigator.of(ctx).pop(),
                      ),
                    );
                  } else if (tool.targetRoute.isNotEmpty) {
                    context.push(tool.targetRoute);
                  }
                },
              ),

              const SizedBox(height: 18),

              // 5. Banner de acceso al módulo de Relajación y Pausas Activas
              const _RelaxationBanner(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Banner estático optimizado como widget const inmutable.
class _RelaxationBanner extends StatelessWidget {
  const _RelaxationBanner();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('wellness_relaxation_banner'),
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(AppRoutes.relaxation),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF2F7F4), Color(0xFFEAF3ED)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: MindColors.primary.withValues(alpha: 0.2),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: MindColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.self_improvement_rounded,
                  color: MindColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Relajación y Pausas Activas',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: MindColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Estiramientos de cuello, espalda, mandíbula y vista.',
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
                color: MindColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
