import 'package:flutter/material.dart';
import '../../../../core/design_system/avatars/mind_user_avatar.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/theme/mind_colors.dart';

/// Cabecera superior serena para la pantalla de Perfil.
/// Incluye logotipo mindUC, título centrado Perfil y accesos rápidos de configuración y cuenta.
class ProfileHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final VoidCallback? onAccountTap;
  final String? avatarUrl;

  const ProfileHeader({
    super.key,
    this.onSettingsTap,
    this.onAccountTap,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logotipo oficial e identidad mindUC a la izquierda
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MindAppLogo(size: 32),
              SizedBox(width: 8),
              Text(
                'mindUC',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E6347),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          // Título Perfil centrado
          const Text(
            'Perfil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: MindColors.textPrimary,
            ),
          ),

          // Iconos de acción a la derecha
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 22,
                  color: MindColors.textPrimary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onSettingsTap,
                tooltip: 'Configuración',
              ),
              const SizedBox(width: 14),
              if (avatarUrl != null)
                MindUserAvatar(
                  avatarId: avatarUrl,
                  size: 32,
                  onTap: onAccountTap,
                )
              else
                InkWell(
                  onTap: onAccountTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF385C4B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
