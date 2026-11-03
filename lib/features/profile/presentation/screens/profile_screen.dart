import 'package:flutter/material.dart';
import '../../../../core/design_system/buttons/mind_button.dart';
import '../../../../core/design_system/cards/mind_card.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MindColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          children: [
            // Student Profile Card
            MindCard(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  const Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: MindColors.autocuidado,
                        child: Icon(Icons.person, size: 48, color: MindColors.primaryDark),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: MindColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Camila Soto', style: MindTypography.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    'Psicología',
                    style: MindTypography.bodyMedium.copyWith(color: MindColors.textSecondary),
                  ),
                  Text(
                    'camila.soto@uc.cl',
                    style: MindTypography.labelSmall.copyWith(color: MindColors.textTertiary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Wellness preferences
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PREFERENCIAS DE BIENESTAR', style: MindTypography.labelSmall),
                const Icon(Icons.tune_rounded, size: 16, color: MindColors.textTertiary),
              ],
            ),
            const SizedBox(height: 12),

            MindCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  _PreferenceItem(
                    icon: Icons.cloud_outlined,
                    iconBg: MindColors.autocuidado,
                    iconColor: MindColors.autocuidadoAccent,
                    title: 'Sonido ambiental predeterminado',
                    subtitle: 'Lluvia suave en el bosque',
                    onTap: () {},
                  ),
                  const Divider(color: MindColors.divider, height: 20),
                  _PreferenceItem(
                    icon: Icons.air_rounded,
                    iconBg: MindColors.estudioTrabajo,
                    iconColor: MindColors.estudioTrabajoAccent,
                    title: 'Técnica de respiración favorita',
                    subtitle: 'Caja 4–4–4',
                    onTap: () {},
                  ),
                  const Divider(color: MindColors.divider, height: 20),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: MindColors.autocuidado,
                        child: Icon(Icons.notifications_active_outlined, color: MindColors.autocuidadoAccent, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recordatorios conscientes', style: MindTypography.titleMedium.copyWith(fontSize: 14)),
                            Text('Pausas cada 2 horas de estudio', style: MindTypography.labelSmall),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: true,
                        activeThumbColor: MindColors.primary,
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Institutional crisis support
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SOPORTE INSTITUCIONAL', style: MindTypography.labelSmall),
                const Icon(Icons.shield_outlined, size: 16, color: MindColors.primaryDark),
              ],
            ),
            const SizedBox(height: 12),

            MindCard(
              backgroundColor: MindColors.autocuidado,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.phone_in_talk_rounded, color: MindColors.primaryDark, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Línea de Apoyo Psicológico', style: MindTypography.titleMedium.copyWith(fontSize: 14)),
                        Text('Anexo universitario confidencial', style: MindTypography.labelSmall),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MindColors.primaryDark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    onPressed: () {},
                    child: const Text('Llamar ↗', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout
            MindButton(
              text: 'Cerrar sesión en este dispositivo',
              variant: MindButtonVariant.outlined,
              icon: Icons.logout_rounded,
              onPressed: () {},
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PreferenceItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PreferenceItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconBg,
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: MindTypography.titleMedium.copyWith(fontSize: 14)),
                Text(subtitle, style: MindTypography.labelSmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: MindColors.textTertiary),
        ],
      ),
    );
  }
}
