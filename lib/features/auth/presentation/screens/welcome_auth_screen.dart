import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/branding/mind_app_logo.dart';
import '../../../../core/design_system/buttons/mind_button.dart';
import '../../../../core/design_system/cards/mind_card.dart';
import '../../../../core/design_system/inputs/mind_input_field.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';
import '../../../agenda/presentation/controllers/agenda_controller.dart';
import '../../../community_forum/presentation/controllers/community_controller.dart';
import '../../../focus_pomodoro/presentation/controllers/app_blocker_controller.dart';
import '../../../home/presentation/controllers/home_dashboard_controller.dart';
import '../../../personal_journal/presentation/controllers/journal_controller.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../progress_gamification/presentation/controllers/progress_controller.dart';
import '../../domain/entities/app_avatar.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_segmented_switch.dart';
import '../widgets/avatar_selector_row.dart';
import '../widgets/password_reset_dialog.dart';

/// Pantalla oficial de Bienvenida y Autenticación de mindUC según Figma.
class WelcomeAuthScreen extends ConsumerStatefulWidget {
  const WelcomeAuthScreen({super.key});

  @override
  ConsumerState<WelcomeAuthScreen> createState() => _WelcomeAuthScreenState();
}

class _WelcomeAuthScreenState extends ConsumerState<WelcomeAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedAvatarId = AppAvatar.defaultAvatar.id;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final authNotifier = ref.read(authUiControllerProvider.notifier);
    final isLogin = ref.read(authUiControllerProvider).isLoginMode;

    if (!isLogin && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu nombre')),
      );
      return;
    }

    final success = await authNotifier.submit(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: isLogin ? null : _nameController.text.trim(),
      department: isLogin ? null : _departmentController.text.trim(),
      photoUrl: isLogin ? null : _selectedAvatarId,
    );

    if (success && mounted) {
      ref.invalidate(currentUserProvider);
      ref.invalidate(profileControllerProvider);
      ref.invalidate(homeDashboardControllerProvider);
      ref.invalidate(agendaControllerProvider);
      ref.invalidate(journalControllerProvider);
      ref.invalidate(progressControllerProvider);
      ref.invalidate(appBlockerControllerProvider);
      ref.invalidate(communityControllerProvider);
      try {
        context.go(AppRoutes.home);
      } catch (_) {}
    }
  }

  void _showPasswordResetDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => PasswordResetDialog(
        initialEmail: _emailController.text.trim(),
        onSubmit: (email) => ref.read(authUiControllerProvider.notifier).sendPasswordReset(email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authUiControllerProvider);
    final authNotifier = ref.read(authUiControllerProvider.notifier);

    return Scaffold(
      backgroundColor: MindColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Botanical central emblem / Official App Logo
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MindColors.primary.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: MindAppLogo(size: 72),
                  ),
                ),
                const SizedBox(height: 16),

                // Student wellness badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: MindColors.estudioTrabajo,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.eco_rounded, size: 14, color: MindColors.estudioTrabajoAccent),
                      const SizedBox(width: 6),
                      Text(
                        'Espacio de Bienestar Estudiantil',
                        style: MindTypography.labelSmall.copyWith(
                          color: MindColors.estudioTrabajoAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Headline
                Text(
                  'Encuentra tu centro en el ritmo universitario',
                  textAlign: TextAlign.center,
                  style: MindTypography.titleLarge.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),

                // Subheadline
                Text(
                  'Un espacio seguro y compasivo para cultivar tus hábitos, claridad mental y paz interior.',
                  textAlign: TextAlign.center,
                  style: MindTypography.bodyMedium.copyWith(height: 1.4),
                ),
                const SizedBox(height: 24),

                // Main Form Card
                MindCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Segmented switch
                      AuthSegmentedSwitch(
                        isLoginMode: authState.isLoginMode,
                        onChanged: (isLogin) => authNotifier.setLoginMode(isLogin),
                      ),
                      const SizedBox(height: 20),

                      // Optional registration fields
                      if (!authState.isLoginMode) ...[
                        // Selector de avatar de animal (🐼 Oso panda, 🐨 Koala, 🐯 Tigre)
                        AvatarSelectorRow(
                          selectedAvatarId: _selectedAvatarId,
                          onAvatarSelected: (avatar) {
                            setState(() => _selectedAvatarId = avatar.id);
                          },
                        ),
                        const SizedBox(height: 18),
                        MindInputField(
                          label: 'Nombre completo',
                          hintText: 'Tu nombre completo',
                          controller: _nameController,
                          prefixIcon: const Icon(Icons.person_outline, size: 20, color: MindColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        MindInputField(
                          label: 'Carrera o área de estudio',
                          hintText: 'ej. Psicología, Ingeniería',
                          controller: _departmentController,
                          prefixIcon: const Icon(Icons.school_outlined, size: 20, color: MindColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email field
                      MindInputField(
                        label: 'Correo institucional o personal',
                        hintText: 'estudiante@uc.cl',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20, color: MindColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      // Password field with label row and visibility toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Contraseña',
                            style: MindTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (authState.isLoginMode)
                            Flexible(
                              child: GestureDetector(
                                onTap: _showPasswordResetDialog,
                                child: Text(
                                  '¿Olvidaste tu contraseña?',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: MindTypography.labelSmall.copyWith(
                                    color: MindColors.primaryDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      MindInputField(
                        hintText: '•••••••••••••',
                        controller: _passwordController,
                        obscureText: !authState.isPasswordVisible,
                        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: MindColors.textSecondary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            authState.isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: MindColors.textSecondary,
                          ),
                          onPressed: () => authNotifier.togglePasswordVisibility(),
                        ),
                      ),

                      // Error message banner
                      if (authState.errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: MindColors.saludMental,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 16, color: MindColors.saludMentalAccent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authState.errorMessage!,
                                  style: MindTypography.labelSmall.copyWith(
                                    color: MindColors.saludMentalAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Primary button
                      MindButton(
                        text: authState.isLoginMode ? 'Ingresar a mi espacio' : 'Crear mi cuenta',
                        icon: Icons.notifications_none_rounded,
                        isLoading: authState.isLoading,
                        width: double.infinity,
                        onPressed: _handleSubmit,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tagline footer
                Text(
                  '• Ritmo guiado • Diario reflexivo • Calma activa •',
                  textAlign: TextAlign.center,
                  style: MindTypography.labelSmall.copyWith(
                    color: MindColors.textTertiary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);
  }
}
