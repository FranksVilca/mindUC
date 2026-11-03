import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/datasources/local_profile_datasource.dart';
import '../controllers/profile_controller.dart';
import '../widgets/institutional_support_card.dart';
import '../widgets/logout_button.dart';
import '../widgets/preference_selection_modal.dart';
import '../widgets/profile_header.dart';
import '../widgets/student_identity_card.dart';
import '../widgets/support_contact_modal.dart';
import '../widgets/wellness_preferences_card.dart';

/// Pantalla principal de Perfil y Configuración del estudiante (mindUC).
/// Implementada bajo Clean Architecture Feature-First y Riverpod StateNotifier.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    final notifier = ref.read(profileControllerProvider.notifier);

    return Scaffold(
      backgroundColor: MindColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera superior con logotipo e iconos de acción
            ProfileHeader(
              onSettingsTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuración avanzada disponible próximamente.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              onAccountTap: () {},
            ),

            // Contenido con scroll vertical suave
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  children: [
                    // 1. Tarjeta de Identidad del Estudiante
                    StudentIdentityCard(user: profileState.user),
                    const SizedBox(height: 24.0),

                    // 2. Preferencias de Bienestar
                    WellnessPreferencesCard(
                      preferences: profileState.preferences,
                      onSoundTap: () {
                        PreferenceSelectionModal.show(
                          context: context,
                          title: 'Sonido ambiental predeterminado',
                          subtitle: 'Selecciona el paisaje sonoro que te acompañe en tus sesiones',
                          options: LocalProfileDataSource.availableAmbientSounds,
                          selectedOption: profileState.preferences.defaultAmbientSound,
                          onSelected: (sound) => notifier.selectAmbientSound(sound),
                        );
                      },
                      onTechniqueTap: () {
                        PreferenceSelectionModal.show(
                          context: context,
                          title: 'Técnica de respiración favorita',
                          subtitle: 'Escoge tu ejercicio preferido para restaurar la calma',
                          options: LocalProfileDataSource.availableBreathingTechniques,
                          selectedOption: profileState.preferences.favoriteBreathingTechnique,
                          onSelected: (technique) => notifier.selectBreathingTechnique(technique),
                        );
                      },
                      onRemindersChanged: (val) {
                        notifier.toggleConsciousReminders(val);
                      },
                    ),
                    const SizedBox(height: 24.0),

                    // 3. Soporte Institucional Confidencial
                    InstitutionalSupportCard(
                      contact: profileState.supportContact,
                      onCallTap: () {
                        SupportContactModal.show(
                          context: context,
                          contact: profileState.supportContact,
                          onCallNow: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Conectando con la Línea de Apoyo Psicológico...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),

                    // 4. Cierre de sesión seguro en este dispositivo
                    LogoutButton(
                      isLoading: profileState.isLoading,
                      onPressed: () => _showLogoutDialog(context, ref),
                    ),
                    const SizedBox(height: 36.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: const Text(
          '¿Cerrar sesión en este dispositivo?',
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w700,
            color: MindColors.textPrimary,
          ),
        ),
        content: const Text(
          'Tus reflexiones personales y preferencias seguirán guardadas de forma segura en este dispositivo.',
          style: TextStyle(
            fontSize: 13.5,
            color: MindColors.textSecondary,
            height: 1.35,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: MindColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD35D47),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(profileControllerProvider.notifier).logout();
      await ref.read(authRepositoryProvider).signOut();
      if (context.mounted) {
        context.go(AppRoutes.auth);
      }
    }
  }
}
