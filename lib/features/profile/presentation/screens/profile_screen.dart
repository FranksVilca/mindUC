import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../agenda/presentation/controllers/agenda_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../community_forum/presentation/controllers/community_controller.dart';
import '../../../focus_pomodoro/presentation/controllers/app_blocker_controller.dart';
import '../../../home/presentation/controllers/home_dashboard_controller.dart';
import '../../../personal_journal/presentation/controllers/journal_controller.dart';
import '../../../progress_gamification/presentation/controllers/progress_controller.dart';
import '../../data/datasources/local_profile_datasource.dart';
import '../controllers/profile_controller.dart';
import '../../domain/entities/user_profile.dart';
import '../widgets/institutional_support_card.dart';
import '../widgets/logout_button.dart';
import '../widgets/preference_selection_modal.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_settings_modal.dart';
import '../widgets/student_identity_card.dart';
import '../widgets/support_contact_modal.dart';
import '../widgets/wellness_preferences_card.dart';

/// Pantalla principal de Perfil y Configuración del estudiante (mindUC).
/// Implementada bajo Clean Architecture Feature-First y Riverpod StateNotifier.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _openSettingsModal(
    BuildContext context,
    UserProfile user,
    ProfileNotifier notifier,
  ) {
    ProfileSettingsModal.show(
      context: context,
      user: user,
      onSave: (fullName, career, email, [avatarUrl]) async {
        final success = await notifier.updateUserProfile(
          fullName: fullName,
          career: career,
          universityEmail: email,
          avatarUrl: avatarUrl,
        );
        if (context.mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Perfil actualizado correctamente 🌿'),
                backgroundColor: Color(0xFF2E6347),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Error al guardar los cambios del perfil.'),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        }
      },
    );
  }

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
              avatarUrl: profileState.user.avatarUrl,
              onSettingsTap: () =>
                  _openSettingsModal(context, profileState.user, notifier),
              onAccountTap: () =>
                  _openSettingsModal(context, profileState.user, notifier),
            ),

            // Contenido con scroll vertical suave
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  children: [
                    // 1. Tarjeta de Identidad del Estudiante
                    StudentIdentityCard(
                      user: profileState.user,
                      onEdit: () =>
                          _openSettingsModal(context, profileState.user, notifier),
                    ),
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
                      onReminderIntervalTap: () {
                        PreferenceSelectionModal.show(
                          context: context,
                          title: 'Frecuencia de pausas conscientes',
                          subtitle: 'Configura cada cuánto tiempo deseas recibir pausas de bienestar',
                          options: LocalProfileDataSource.availableReminderIntervals,
                          selectedOption: profileState.preferences.reminderIntervalDescription,
                          onSelected: (interval) => notifier.selectReminderInterval(interval),
                        );
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
      ref.invalidate(currentUserProvider);
      ref.invalidate(profileControllerProvider);
      ref.invalidate(homeDashboardControllerProvider);
      ref.invalidate(agendaControllerProvider);
      ref.invalidate(journalControllerProvider);
      ref.invalidate(progressControllerProvider);
      ref.invalidate(appBlockerControllerProvider);
      ref.invalidate(communityControllerProvider);
      if (context.mounted) {
        context.go(AppRoutes.auth);
      }
    }
  }
}
