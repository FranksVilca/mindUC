import 'package:flutter/material.dart';

/// Tipos de avatares ficticios botánicos y de naturaleza serena para el foro.
enum CommunityAvatar {
  moon(
    icon: Icons.nightlight_round,
    backgroundColor: Color(0xFFE8E5F4),
    iconColor: Color(0xFF6B6396),
  ),
  sprout(
    icon: Icons.eco_rounded,
    backgroundColor: Color(0xFFE2F0E7),
    iconColor: Color(0xFF3B5648),
  ),
  raindrop(
    icon: Icons.water_drop_rounded,
    backgroundColor: Color(0xFFE8EEF5),
    iconColor: Color(0xFF4C6B8B),
  ),
  flower(
    icon: Icons.spa_rounded,
    backgroundColor: Color(0xFFFDECE8),
    iconColor: Color(0xFFD66885),
  );

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const CommunityAvatar({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}
