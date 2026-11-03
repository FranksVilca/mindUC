import 'package:flutter/material.dart';
import '../../../../core/design_system/cards/mind_card.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMood = 'Calma';

  final List<(String, String, Color)> _moods = const [
    ('Calma', '😌', MindColors.autocuidado),
    ('Feliz', '✨', MindColors.saludMental),
    ('Ansiosa', '🌧️', MindColors.estudioTrabajo),
    ('Cansada', '☕', MindColors.surfaceSubtle),
    ('Enérgica', '🌱', MindColors.autocuidado),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MindColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: MindColors.autocuidado,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: MindColors.primaryDark),
                  const SizedBox(width: 6),
                  Text(
                    'Jueves, 24 de Octubre',
                    style: MindTypography.labelSmall.copyWith(
                      color: MindColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Greeting
            Text('¡Hola, Camila! 🌿', style: MindTypography.displayLarge),
            const SizedBox(height: 4),
            Text('¿Cómo te sientes en este momento?', style: MindTypography.bodyMedium),
            const SizedBox(height: 24),

            // Mood Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tu estado de ánimo', style: MindTypography.titleMedium),
                Text('Selecciona uno', style: MindTypography.labelSmall),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => setState(() => _selectedMood = mood.$1),
                      child: Container(
                        width: 68,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: mood.$3,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? MindColors.primary : Colors.transparent,
                            width: 1.8,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(mood.$2, style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 6),
                            Text(
                              mood.$1,
                              style: MindTypography.labelSmall.copyWith(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 28),

            // Spaces For You
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Espacios para ti', style: MindTypography.titleMedium),
                Text('Explora tu bienestar', style: MindTypography.labelSmall),
              ],
            ),
            const SizedBox(height: 14),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.15,
              children: [
                _HubCard(
                  title: 'Relajación',
                  subtitle: 'Respira y libera tensión (10 min)',
                  icon: Icons.self_improvement_rounded,
                  color: MindColors.autocuidado,
                  accentColor: MindColors.autocuidadoAccent,
                  onTap: () {},
                ),
                _HubCard(
                  title: 'Agenda',
                  subtitle: '4 actividades pendientes hoy',
                  icon: Icons.calendar_month_outlined,
                  color: MindColors.estudioTrabajo,
                  accentColor: MindColors.estudioTrabajoAccent,
                  onTap: () {},
                ),
                _HubCard(
                  title: 'Comunidad',
                  subtitle: 'Conecta en el foro anónimo UC',
                  icon: Icons.people_outline_rounded,
                  color: MindColors.saludMental,
                  accentColor: MindColors.saludMentalAccent,
                  onTap: () {},
                ),
                _HubCard(
                  title: 'Mi progreso',
                  subtitle: 'Racha de 7 días continuos',
                  icon: Icons.auto_graph_rounded,
                  color: MindColors.surfaceSubtle,
                  accentColor: MindColors.primaryDark,
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

class _HubCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color accentColor;
  final VoidCallback onTap;

  const _HubCard({
    required this.title,
    required this.subtitle,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(icon, color: accentColor, size: 20),
              ),
              Icon(Icons.arrow_forward_rounded, color: accentColor, size: 18),
            ],
          ),
          const Spacer(),
          Text(title, style: MindTypography.titleMedium.copyWith(fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: MindTypography.labelSmall.copyWith(fontSize: 11, height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
