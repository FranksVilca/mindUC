import 'package:flutter/material.dart';
import '../../../../core/design_system/cards/mind_card.dart';
import '../../../../core/design_system/chips/mind_chip.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  int _selectedDay = 24;
  String _selectedFilter = 'Todas';

  final List<(String, int)> _weekDays = const [
    ('Lun', 21),
    ('Mar', 22),
    ('Mié', 23),
    ('Jue', 24),
    ('Vie', 25),
    ('Sáb', 26),
    ('Dom', 27),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MindColors.background,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'voice_btn',
            backgroundColor: Colors.white,
            foregroundColor: MindColors.primaryDark,
            elevation: 2,
            shape: const CircleBorder(),
            onPressed: () {},
            child: const Icon(Icons.mic_none_rounded, size: 24),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.extended(
            heroTag: 'new_task_btn',
            backgroundColor: MindColors.primaryLight,
            foregroundColor: MindColors.primaryDark,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {},
            icon: const Icon(Icons.add, size: 20),
            label: Text(
              'Nueva',
              style: MindTypography.labelLarge.copyWith(color: MindColors.primaryDark),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mi Agenda consciente', style: MindTypography.titleLarge),
            const SizedBox(height: 2),
            Row(
              children: [
                Text('Jueves, Octubre 2024', style: MindTypography.bodyMedium),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: MindColors.textTertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Semana 43', style: MindTypography.bodyMedium),
              ],
            ),
            const SizedBox(height: 18),

            // Week Day Strip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _weekDays.map((d) {
                final isSelected = _selectedDay == d.$2;
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => setState(() => _selectedDay = d.$2),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? MindColors.autocuidado : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? MindColors.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(d.$1, style: MindTypography.labelSmall.copyWith(fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(
                          '${d.$2}',
                          style: MindTypography.titleMedium.copyWith(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected ? MindColors.primary : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Progress balance card
            MindCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: MindColors.autocuidado,
                    child: Icon(Icons.eco_rounded, color: MindColors.primaryDark, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ritmo en equilibrio', style: MindTypography.titleMedium.copyWith(fontSize: 15)),
                      Text('4 actividades · 2 completadas', style: MindTypography.labelSmall),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'Historial >',
                    style: MindTypography.labelSmall.copyWith(
                      color: MindColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Filters
            Row(
              children: [
                MindChip(
                  label: 'Todas',
                  isSelected: _selectedFilter == 'Todas',
                  onTap: () => setState(() => _selectedFilter = 'Todas'),
                ),
                const SizedBox(width: 8),
                MindChip(
                  label: 'Autocuidado',
                  dotColor: MindColors.autocuidadoAccent,
                  isSelected: _selectedFilter == 'Autocuidado',
                  onTap: () => setState(() => _selectedFilter = 'Autocuidado'),
                ),
                const SizedBox(width: 8),
                MindChip(
                  label: 'Estudio / Trabajo',
                  dotColor: MindColors.estudioTrabajoAccent,
                  isSelected: _selectedFilter == 'Estudio / Trabajo',
                  onTap: () => setState(() => _selectedFilter = 'Estudio / Trabajo'),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Tasks items
            const _TaskTile(
              time: '08:00 AM',
              title: 'Meditación matutina y respiración',
              subtitle: '10 min de enfoque guiado para iniciar el día en calma.',
              category: 'Autocuidado',
              categoryBg: MindColors.autocuidado,
              categoryAccent: MindColors.autocuidadoAccent,
              isCompleted: true,
            ),
            const _TaskTile(
              time: '11:30 AM',
              title: 'Sesión de estudio concentrado (Pomodoro)',
              subtitle: 'Lectura de apuntes y revisión de metas semanales.',
              category: 'Trabajo',
              categoryBg: MindColors.estudioTrabajo,
              categoryAccent: MindColors.estudioTrabajoAccent,
              isCompleted: true,
            ),
            const _TaskTile(
              time: '16:00 PM',
              title: 'Caminata al aire libre sin pantallas',
              subtitle: '25 min en el parque para despejar la vista y desconectar.',
              category: 'Salud mental',
              categoryBg: MindColors.saludMental,
              categoryAccent: MindColors.saludMentalAccent,
              isCompleted: false,
            ),
            const _TaskTile(
              time: '21:30 PM',
              title: 'Escribir en mi Diario Personal de gratitud',
              subtitle: 'Anotar 3 momentos significativos vividos hoy.',
              category: 'Autocuidado',
              categoryBg: MindColors.autocuidado,
              categoryAccent: MindColors.autocuidadoAccent,
              isCompleted: false,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final String category;
  final Color categoryBg;
  final Color categoryAccent;
  final bool isCompleted;

  const _TaskTile({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.categoryBg,
    required this.categoryAccent,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: MindCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isCompleted ? MindColors.autocuidado : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? MindColors.autocuidadoAccent : MindColors.divider,
                  width: 1.5,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: MindColors.autocuidadoAccent)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(time, style: MindTypography.labelSmall),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: categoryBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: categoryAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              category,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: categoryAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: MindTypography.titleMedium.copyWith(
                      fontSize: 14.5,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted ? MindColors.textSecondary : MindColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: MindTypography.bodyMedium.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
