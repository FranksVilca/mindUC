import 'package:flutter/material.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';

/// Entidad inmutable que representa cada una de las herramientas de la cuadrícula de autocuidado.
class WellnessToolItem {
  final String id;
  final String title;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final Color backgroundColor;
  final String targetRoute;
  final bool isDeferred;

  const WellnessToolItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.icon,
    required this.backgroundColor,
    required this.targetRoute,
    this.isDeferred = false,
  });

  /// Catálogo de las 4 herramientas oficiales del mockup `mindUC - Bienestar.png`.
  static const List<WellnessToolItem> defaultTools = [
    WellnessToolItem(
      id: 'breathing',
      title: 'Respiración',
      subtitle: 'Guía rítmica para calmar mente y...',
      badgeText: '3 min',
      icon: Icons.air,
      backgroundColor: MindColors.autocuidado,
      targetRoute: AppRoutes.breathingSession,
    ),
    WellnessToolItem(
      id: 'journal',
      title: 'Diario personal',
      subtitle: 'Expresa tus pensamientos sin...',
      badgeText: 'Privado',
      icon: Icons.edit_note_rounded,
      backgroundColor: MindColors.estudioTrabajo,
      targetRoute: AppRoutes.journalNew,
    ),
    WellnessToolItem(
      id: 'ai_assistant',
      title: 'Psicólogo IA ✨',
      subtitle: 'Escucha compasiva y orientación 24/7.',
      badgeText: 'Gratis 24/7',
      icon: Icons.psychology_outlined,
      backgroundColor: MindColors.descanso,
      targetRoute: AppRoutes.aiAssistant,
      isDeferred: false,
    ),
    WellnessToolItem(
      id: 'pomodoro',
      title: 'Concentración',
      subtitle: 'Bloques con sonidos de la naturaleza.',
      badgeText: '25m',
      icon: Icons.timer_outlined,
      backgroundColor: MindColors.saludMental,
      targetRoute: AppRoutes.pomodoroSession,
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellnessToolItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
