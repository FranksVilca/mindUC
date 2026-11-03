import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/user_profile.dart';

/// Tarjeta de identidad del estudiante con avatar circular, presencia consciente y datos institucionales.
class StudentIdentityCard extends StatelessWidget {
  final UserProfile user;

  const StudentIdentityCard({
    super.key,
    required this.user,
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
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8F1EC),
                  border: Border.all(
                    color: const Color(0xFFD3E4DA),
                    width: 3.0,
                  ),
                ),
                child: ClipOval(
                  child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                      ? Image.network(
                          user.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildAvatarFallback(),
                        )
                      : _buildAvatarFallback(),
                ),
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

          // Nombre del estudiante
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: MindColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4.0),

          // Carrera
          Text(
            user.career,
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

  Widget _buildAvatarFallback() {
    return const Center(
      child: Icon(
        Icons.person_rounded,
        size: 64.0,
        color: Color(0xFF385C4B),
      ),
    );
  }
}
