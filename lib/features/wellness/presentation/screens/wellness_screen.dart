import 'package:flutter/material.dart';
import '../../../../core/design_system/buttons/mind_button.dart';
import '../../../../core/design_system/cards/mind_card.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';

class WellnessScreen extends StatelessWidget {
  const WellnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MindColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sanctuary mode pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: MindColors.autocuidado,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.eco_rounded, size: 14, color: MindColors.primaryDark),
                  const SizedBox(width: 6),
                  Text(
                    'SANCTUARY MODE',
                    style: MindTypography.labelSmall.copyWith(
                      color: MindColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Text('Tu espacio de bienestar ✨', style: MindTypography.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Tómate una pausa consciente. Cada pequeño respiro renueva tu energía interior.',
              style: MindTypography.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Hero suggested exercise
            MindCard(
              backgroundColor: MindColors.autocuidado,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('EJERCICIO SUGERIDO PARA TI HOY', style: MindTypography.labelSmall),
                          const SizedBox(height: 4),
                          Text('Respiración 4–7–8', style: MindTypography.titleMedium),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.air_rounded, color: MindColors.primaryDark, size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Técnica antiestrés recomendada para despejar la sobrecarga',
                    style: MindTypography.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: MindColors.primaryDark,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('Ciclo guiado', style: MindTypography.labelSmall),
                        ],
                      ),
                      MindButton(
                        text: 'Comenzar (5 min)',
                        height: 42,
                        icon: Icons.play_arrow_rounded,
                        variant: MindButtonVariant.secondary,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2x2 Grid of Modules
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.05,
              children: [
                _ModuleCard(
                  title: 'Respiración',
                  subtitle: 'Guía rítmica para calmar mente y cuerpo',
                  badge: '3 min',
                  icon: Icons.air_rounded,
                  color: MindColors.autocuidado,
                  accentColor: MindColors.autocuidadoAccent,
                  onTap: () {},
                ),
                _ModuleCard(
                  title: 'Diario personal',
                  subtitle: 'Expresa tus pensamientos sin juicios',
                  badge: 'Privado',
                  icon: Icons.book_outlined,
                  color: MindColors.estudioTrabajo,
                  accentColor: MindColors.estudioTrabajoAccent,
                  onTap: () {},
                ),
                _ModuleCard(
                  title: 'Asistente IA ✨',
                  subtitle: 'Acompañamiento y escucha compasiva.',
                  badge: '24/7',
                  icon: Icons.smart_toy_outlined,
                  color: MindColors.descanso,
                  accentColor: MindColors.descansoAccent,
                  onTap: () {},
                ),
                _ModuleCard(
                  title: 'Concentración',
                  subtitle: 'Bloques con sonidos de la naturaleza.',
                  badge: '25m',
                  icon: Icons.timer_outlined,
                  color: MindColors.saludMental,
                  accentColor: MindColors.saludMentalAccent,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final Color color;
  final Color accentColor;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.color,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MindCard(
      backgroundColor: color,
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Icon(icon, color: accentColor, size: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: accentColor),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(title, style: MindTypography.titleMedium.copyWith(fontSize: 15)),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: MindTypography.labelSmall.copyWith(fontSize: 10.5, height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

