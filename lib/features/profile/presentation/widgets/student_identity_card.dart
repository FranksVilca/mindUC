import 'package:flutter/material.dart';
import '../../../../core/design_system/avatars/mind_user_avatar.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/user_profile.dart';

/// Tarjeta de identidad del estudiante con avatar circular, presencia consciente y datos institucionales.
class StudentIdentityCard extends StatelessWidget {
  final UserProfile user;
  final VoidCallback? onEdit;

  const StudentIdentityCard({
    super.key,
    required this.user,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar con indicador de presencia consciente
          Stack(
            children: [
              MindUserAvatar(
                key: const Key('profile_avatar_image'),
                avatarId: user.avatarUrl,
                size: 120.0,
                showBorder: true,
              ),

              // Indicador circular verde de presencia consciente
              if (user.isMindfulActive)
                Positioned(
                  right: 6.0,
                  bottom: 6.0,
                  child: Container(
                    key: const Key('profile_presence_dot'),
                    width: 18.0,
                    height: 18.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B7A57),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 4.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Nombre del estudiante y botón de edición
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  user.fullName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: MindColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              if (onEdit != null) ...[
                const SizedBox(width: 6.0),
                IconButton(
                  key: const Key('student_identity_edit_btn'),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: MindColors.primaryDark,
                  ),
                  onPressed: onEdit,
                  tooltip: 'Editar perfil',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4.0),

          // Carrera
          Text(
            user.career,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              color: MindColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2.0),

          // Correo institucional
          Text(
            user.universityEmail,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: MindColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
