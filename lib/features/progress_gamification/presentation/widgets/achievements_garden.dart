import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/organic_achievement.dart';

/// Sección "Jardín de logros" con reconocimientos botánicos a la constancia (Principio III).
class AchievementsGarden extends StatelessWidget {
  const AchievementsGarden({
    super.key,
    required this.achievements,
    required this.bloomedCount,
    required this.totalCount,
  });

  final List<OrganicAchievement> achievements;
  final int bloomedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con insignia de logros florecidos
          Row(
            children: [
              const Text(
                'Jardín de logros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: MindColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 8),
              if (totalCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F0E7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFCEE3D5),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    '$bloomedCount de $totalCount',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C4C3B),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F5F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: MindColors.divider,
                      width: 0.8,
                    ),
                  ),
                  child: const Text(
                    '0 logros',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: MindColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Reconocimientos orgánicos a tu constancia',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: MindColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // Contenido: estado en blanco o cuadrícula de logros
          if (achievements.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: MindColors.divider),
              ),
              child: const Column(
                children: [
                  Icon(Icons.eco_outlined, color: Color(0xFF90C2A8), size: 30),
                  SizedBox(height: 8),
                  Text(
                    'Tu jardín comenzará a florecer conforme realices pausas conscientes, sesiones de enfoque y reflexiones en tu diario 🌿',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: MindColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )
          else if (achievements.length >= 4) ...[
            Row(
              children: [
                Expanded(child: _buildAchievementCard(achievements[0])),
                const SizedBox(width: 12),
                Expanded(child: _buildAchievementCard(achievements[1])),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildAchievementCard(achievements[2])),
                const SizedBox(width: 12),
                Expanded(child: _buildAchievementCard(achievements[3])),
              ],
            ),
          ] else
            Column(
              children: achievements.map(_buildAchievementCard).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(OrganicAchievement achievement) {
    Color cardBg;
    Color iconColor;
    Color pillBg;
    Color pillTextColor;

    switch (achievement.category) {
      case AchievementCategory.peace:
        cardBg = const Color(0xFFEAF1ED);
        iconColor = const Color(0xFF5D8572);
        pillBg = achievement.isBloomed
            ? const Color(0xFFD6EADA)
            : const Color(0xFFF7F5F0);
        pillTextColor = achievement.isBloomed
            ? const Color(0xFF2C4C3B)
            : MindColors.textSecondary;
        break;

      case AchievementCategory.mind:
        cardBg = const Color(0xFFEBE8F7);
        iconColor = const Color(0xFF7B72B8);
        pillBg = achievement.isBloomed
            ? const Color(0xFFDFDAF2)
            : const Color(0xFFF7F5F0);
        pillTextColor = achievement.isBloomed
            ? const Color(0xFF4C4480)
            : MindColors.textSecondary;
        break;

      case AchievementCategory.voice:
        cardBg = const Color(0xFFFCE7E1);
        iconColor = const Color(0xFFD67868);
        pillBg = achievement.isBloomed
            ? const Color(0xFFF7D5CD)
            : const Color(0xFFF7F5F0);
        pillTextColor = achievement.isBloomed
            ? const Color(0xFF994436)
            : MindColors.textSecondary;
        break;

      case AchievementCategory.focus:
        cardBg = const Color(0xFFE5F0F5);
        iconColor = const Color(0xFF5B8A99);
        pillBg = achievement.isBloomed
            ? const Color(0xFFCFE3EC)
            : const Color(0xFFF7F5F0);
        pillTextColor = achievement.isBloomed
            ? const Color(0xFF2E5E6E)
            : MindColors.textSecondary;
        break;
    }

    final IconData icon = _getAchievementIcon(achievement.category);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MindColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MindColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono orgánico y estado florecido
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: cardBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor,
                ),
              ),
              if (achievement.isBloomed)
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: Color(0xFF5D8572),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Título del logro
          Text(
            achievement.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: MindColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 3),

          // Descripción compasiva
          Text(
            achievement.description,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: MindColors.textSecondary,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Estado: Pastilla "✓ Florecida" o Barra de progreso
          if (achievement.isBloomed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '✓ Florecida',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: pillTextColor,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: achievement.progressRatio,
                minHeight: 6,
                backgroundColor: const Color(0xFFD6E0DA),
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              ),
            ),
            if (achievement.progressLabel != null &&
                achievement.progressLabel!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                achievement.progressLabel!,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: MindColors.textSecondary,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  IconData _getAchievementIcon(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.peace:
        return Icons.spa_rounded;
      case AchievementCategory.mind:
        return Icons.psychology_rounded;
      case AchievementCategory.voice:
        return Icons.menu_book_rounded;
      case AchievementCategory.focus:
        return Icons.center_focus_strong_rounded;
    }
  }
}
