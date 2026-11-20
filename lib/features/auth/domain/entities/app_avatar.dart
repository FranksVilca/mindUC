import 'package:flutter/material.dart';

/// Entidad pura de dominio que modela los tres avatares animales oficiales en mindUC:
/// 🐼 Oso panda, 🐨 Koala, 🐯 Tigre.
class AppAvatar {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final Color backgroundColor;
  final Color accentColor;

  const AppAvatar({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.backgroundColor,
    required this.accentColor,
  });

  /// 🐼 Oso panda - Calma, presencia y equilibrio
  static const AppAvatar panda = AppAvatar(
    id: 'panda',
    name: 'Oso panda',
    emoji: '🐼',
    description: 'Serenidad y calma interior',
    backgroundColor: Color(0xFFF1F5F2),
    accentColor: Color(0xFF2E6347),
  );

  /// 🐨 Koala - Pausa consciente, amabilidad y descanso
  static const AppAvatar koala = AppAvatar(
    id: 'koala',
    name: 'Koala',
    emoji: '🐨',
    description: 'Pausa y descanso compasivo',
    backgroundColor: Color(0xFFEFF3F7),
    accentColor: Color(0xFF3E6B89),
  );

  /// 🐯 Tigre - Fuerza, concentración y valentía
  static const AppAvatar tiger = AppAvatar(
    id: 'tiger',
    name: 'Tigre',
    emoji: '🐯',
    description: 'Fuerza, concentración y valentía',
    backgroundColor: Color(0xFFFFF7ED),
    accentColor: Color(0xFFD97706),
  );

  /// Alias de compatibilidad hacia atrás
  static const AppAvatar crocodile = tiger;

  /// Lista oficial de los tres avatares animales
  static const List<AppAvatar> all = [panda, koala, tiger];

  /// Avatar predeterminado si el usuario no selecciona uno explícitamente
  static const AppAvatar defaultAvatar = panda;

  /// Resuelve un avatar según su ID o identificador textual
  static AppAvatar fromId(String? id) {
    if (id == null || id.trim().isEmpty) return defaultAvatar;
    final lower = id.toLowerCase().trim();
    if (lower.contains('koala') || lower == '🐨') return koala;
    if (lower.contains('tiger') ||
        lower.contains('tigre') ||
        lower == '🐯' ||
        lower.contains('croc') ||
        lower.contains('coco') ||
        lower == '🐊') {
      return tiger;
    }
    return panda;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppAvatar &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
