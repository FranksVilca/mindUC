import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/mind_colors.dart';
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
      appBar: const WellnessHeader(),
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

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
