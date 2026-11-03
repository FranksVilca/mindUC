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

          // Cuadrícula 2x2 de tarjetas de logros
          if (achievements.length >= 4) ...[
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
    IconData icon;

    switch (achievement.category) {
      case AchievementCategory.peace:
        cardBg = const Color(0xFFEDF6F0);
        iconColor = const Color(0xFF386B5A);
        pillBg = const Color(0xFFD6EADA);
        pillTextColor = const Color(0xFF2C4C3B);
        icon = Icons.spa_rounded;
        break;
      case AchievementCategory.mind:
        cardBg = const Color(0xFFF2F0FA);
        iconColor = const Color(0xFF6B5899);
        pillBg = const Color(0xFFE5E0F4);
        pillTextColor = const Color(0xFF534185);
        icon = Icons.self_improvement_rounded;
        break;
      case AchievementCategory.voice:
        cardBg = const Color(0xFFFDF0ED);
        iconColor = const Color(0xFFD67868);
        pillBg = const Color(0xFFFCE1DB);
        pillTextColor = const Color(0xFFB55747);
        icon = Icons.menu_book_rounded;
        break;
      case AchievementCategory.focus:
        cardBg = const Color(0xFFEEF3F0);
        iconColor = const Color(0xFF5D756A);
        pillBg = const Color(0xFFD9E5DF);
        pillTextColor = const Color(0xFF3B5648);
        icon = Icons.notifications_off_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withAlpha(8),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono circular
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 19,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 10),

          // Título del logro
          Text(
            achievement.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: MindColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),

          // Descripción compasiva
          Text(
            achievement.description,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.3,
              color: MindColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

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
            if (achievement.progressLabel != null) ...[
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
}

