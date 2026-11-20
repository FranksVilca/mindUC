import 'package:flutter/material.dart';

/// Representa una aplicación disponible en el dispositivo que puede ser bloqueada
/// para evitar distracciones durante las sesiones de concentración.
class BlockedApp {
  const BlockedApp({
    required this.id,
    required this.name,
    required this.packageName,
    this.category = 'Redes sociales',
    this.isBlocked = false,
    this.dotColorValue = 0xFF43A047,
  });

  final String id;
  final String name;
  final String packageName;
  final String category;
  final bool isBlocked;
  final int dotColorValue;

  Color get dotColor => Color(dotColorValue);

  BlockedApp copyWith({
    String? id,
    String? name,
    String? packageName,
    String? category,
    bool? isBlocked,
    int? dotColorValue,
  }) {
    return BlockedApp(
      id: id ?? this.id,
      name: name ?? this.name,
      packageName: packageName ?? this.packageName,
      category: category ?? this.category,
      isBlocked: isBlocked ?? this.isBlocked,
      dotColorValue: dotColorValue ?? this.dotColorValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'packageName': packageName,
      'category': category,
      'isBlocked': isBlocked,
      'dotColorValue': dotColorValue,
    };
  }

  factory BlockedApp.fromJson(Map<String, dynamic> json) {
    return BlockedApp(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      packageName: json['packageName'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      isBlocked: json['isBlocked'] as bool? ?? false,
      dotColorValue: json['dotColorValue'] as int? ?? 0xFF43A047,
    );
  }

  /// Catálogo predeterminado con aplicaciones comunes de distracción académica.
  static const List<BlockedApp> defaultApps = [
    BlockedApp(
      id: 'instagram',
      name: 'Instagram',
      packageName: 'com.instagram.android',
      category: 'Redes sociales',
      isBlocked: true,
      dotColorValue: 0xFFE53935,
    ),
    BlockedApp(
      id: 'tiktok',
      name: 'TikTok',
      packageName: 'com.zhiliaoapp.musically',
      category: 'Redes sociales',
      isBlocked: true,
      dotColorValue: 0xFF7E57C2,
    ),
    BlockedApp(
      id: 'whatsapp',
      name: 'WhatsApp',
      packageName: 'com.whatsapp',
      category: 'Mensajería',
      isBlocked: true,
      dotColorValue: 0xFF43A047,
    ),
    BlockedApp(
      id: 'youtube',
      name: 'YouTube',
      packageName: 'com.google.android.youtube',
      category: 'Streaming & Video',
      isBlocked: false,
      dotColorValue: 0xFFFF0000,
    ),
    BlockedApp(
      id: 'twitter',
      name: 'X (Twitter)',
      packageName: 'com.twitter.android',
      category: 'Redes sociales',
      isBlocked: false,
      dotColorValue: 0xFF1DA1F2,
    ),
    BlockedApp(
      id: 'facebook',
      name: 'Facebook',
      packageName: 'com.facebook.katana',
      category: 'Redes sociales',
      isBlocked: false,
      dotColorValue: 0xFF1877F2,
    ),
    BlockedApp(
      id: 'netflix',
      name: 'Netflix',
      packageName: 'com.netflix.mediaclient',
      category: 'Entretenimiento',
      isBlocked: false,
      dotColorValue: 0xFFE50914,
    ),
    BlockedApp(
      id: 'reddit',
      name: 'Reddit',
      packageName: 'com.reddit.frontpage',
      category: 'Comunidades',
      isBlocked: false,
      dotColorValue: 0xFFFF4500,
    ),
    BlockedApp(
      id: 'discord',
      name: 'Discord',
      packageName: 'com.discord',
      category: 'Mensajería',
      isBlocked: false,
      dotColorValue: 0xFF5865F2,
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockedApp &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          packageName == other.packageName &&
          isBlocked == other.isBlocked;

  @override
  int get hashCode => Object.hash(id, name, packageName, isBlocked);
}
