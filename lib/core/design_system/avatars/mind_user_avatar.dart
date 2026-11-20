import 'package:flutter/material.dart';
import '../../../features/auth/domain/entities/app_avatar.dart';

/// Widget visual unificado para renderizar los avatares de perfil en mindUC.
/// Soporta los tres animales oficiales (🐼 Panda, 🐨 Koala, 🐯 Tigre)
/// y URLs remotas con fallback automático.
class MindUserAvatar extends StatelessWidget {
  final String? avatarId;
  final double size;
  final bool showBorder;
  final VoidCallback? onTap;

  const MindUserAvatar({
    super.key,
    required this.avatarId,
    this.size = 40.0,
    this.showBorder = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = AppAvatar.fromId(avatarId);
    final isNetwork = avatarId != null &&
        (avatarId!.startsWith('http://') || avatarId!.startsWith('https://'));

    Widget avatarContent;

    if (isNetwork) {
      final cacheDim = (size * 2).round();
      avatarContent = Image.network(
        avatarId!,
        fit: BoxFit.cover,
        cacheWidth: cacheDim > 0 ? cacheDim : null,
        cacheHeight: cacheDim > 0 ? cacheDim : null,
        errorBuilder: (_, __, ___) => _buildEmojiContent(avatar),
      );
    } else {
      avatarContent = _buildEmojiContent(avatar);
    }

    final container = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatar.backgroundColor,
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: avatar.accentColor.withValues(alpha: 0.35),
                width: size > 80 ? 3.0 : 1.5,
              )
            : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: avatar.accentColor.withValues(alpha: 0.12),
                  blurRadius: size > 80 ? 12 : 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Center(
            child: avatarContent,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: container,
      );
    }

    return container;
  }

  Widget _buildEmojiContent(AppAvatar avatar) {
    // Escala del emoji adaptada al diámetro del avatar
    final fontSize = size * 0.52;
    return Text(
      avatar.emoji,
      style: TextStyle(
        fontSize: fontSize,
        height: 1.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}
