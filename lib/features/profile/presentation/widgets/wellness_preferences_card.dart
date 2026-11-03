import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/wellness_preferences.dart';

/// Tarjeta de preferencias conscientes de bienestar del estudiante.
class WellnessPreferencesCard extends StatelessWidget {
  final WellnessPreferences preferences;
  final VoidCallback onSoundTap;
  final VoidCallback onTechniqueTap;
  final ValueChanged<bool> onRemindersChanged;

  const WellnessPreferencesCard({
    super.key,
    required this.preferences,
    required this.onSoundTap,
    required this.onTechniqueTap,
    required this.onRemindersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado de sección
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PREFERENCIAS DE BIENESTAR',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: MindColors.textSecondary,
                ),
              ),
              Icon(
                Icons.tune_rounded,
                size: 16.0,
                color: MindColors.textTertiary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),

        // Contenedor de preferencias agrupadas
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 12.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // 1. Sonido ambiental predeterminado
              _PreferenceRow(
                icon: Icons.cloud_outlined,
                iconBg: const Color(0xFFE8F2EC),
                iconColor: const Color(0xFF2C5E47),
                title: 'Sonido ambiental predeterminado',
                subtitle: preferences.defaultAmbientSound,
                onTap: onSoundTap,
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: MindColors.textTertiary,
                  size: 22.0,
                ),
              ),
              const Divider(
                height: 1,
                thickness: 0.8,
                indent: 16.0,
                endIndent: 16.0,
                color: Color(0xFFF0F0F0),
              ),

              // 2. Técnica de respiración favorita
              _PreferenceRow(
                icon: Icons.air_rounded,
                iconBg: const Color(0xFFEDEBF7),
                iconColor: const Color(0xFF6C63FF),
                title: 'Técnica de respiración favorita',
                subtitle: preferences.favoriteBreathingTechnique,
                onTap: onTechniqueTap,
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: MindColors.textTertiary,
                  size: 22.0,
                ),
              ),
              const Divider(
                height: 1,
                thickness: 0.8,
                indent: 16.0,
                endIndent: 16.0,
                color: Color(0xFFF0F0F0),
              ),

              // 3. Recordatorios conscientes
              _PreferenceRow(
                icon: Icons.notifications_none_rounded,
                iconBg: const Color(0xFFE2F4EB),
                iconColor: const Color(0xFF2C5E47),
                title: 'Recordatorios conscientes',
                subtitle: preferences.reminderIntervalDescription,
                onTap: () => onRemindersChanged(!preferences.consciousRemindersEnabled),
                trailing: Switch.adaptive(
                  key: const Key('conscious_reminders_switch'),
                  value: preferences.consciousRemindersEnabled,
                  activeThumbColor: const Color(0xFF385C4B),
                  activeTrackColor: const Color(0xFFBCE3CB),
                  onChanged: onRemindersChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget trailing;

  const _PreferenceRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            // Icono con círculo de color pastel
            Container(
              width: 38.0,
              height: 38.0,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.0,
              ),
            ),
            const SizedBox(width: 14.0),

            // Título y subtítulo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: MindColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      color: MindColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            trailing,
          ],
        ),
      ),
    );
  }
}
