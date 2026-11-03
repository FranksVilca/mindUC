import 'package:flutter/material.dart';

/// Descriptor inmutable de una tarjeta de acceso rápido de la cuadrícula "Espacios para ti".
class QuickAccessItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final String targetRoute;

  const QuickAccessItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.targetRoute,
  });
}

