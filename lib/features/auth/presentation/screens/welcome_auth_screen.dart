import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/buttons/mind_button.dart';
import '../../../../core/design_system/cards/mind_card.dart';
import '../../../../core/design_system/inputs/mind_input_field.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_segmented_switch.dart';
import '../widgets/password_reset_dialog.dart';

/// Pantalla oficial de Bienvenida y Autenticación de mindUC según Figma.
class WelcomeAuthScreen extends ConsumerStatefulWidget {
  const WelcomeAuthScreen({super.key});

  @override
  ConsumerState<WelcomeAuthScreen> createState() => _WelcomeAuthScreenState();
}

class _WelcomeAuthScreenState extends ConsumerState<WelcomeAuthScreen> {
  final _emailController = TextEditingController(text: 'camila.soto@uc.cl');
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController(text: 'Psicología');
  final _formKey = GlobalKey<FormState>();

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

    await authNotifier.submit(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: isLogin ? null : _nameController.text.trim(),
      department: isLogin ? null : _departmentController.text.trim(),
    );
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      color: MindColors.textPrimary,
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'MINDUC',
                          style: MindTypography.labelSmall.copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: MindColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Bienvenida Y Autenticación',
                          style: MindTypography.titleMedium.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: MindColors.primaryDark,
                      child: Icon(Icons.person, size: 18, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Botanical central emblem
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: MindColors.autocuidado,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.spa_rounded,
                      size: 34,
                      color: MindColors.primaryDark,
                    ),
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

                      // Optional registration name field
                      if (!authState.isLoginMode) ...[
                        MindInputField(
                          label: 'Nombre completo',
                          hintText: 'Camila Soto',
                          controller: _nameController,
                          prefixIcon: const Icon(Icons.person_outline, size: 20, color: MindColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        MindInputField(
                          label: 'Carrera o área de estudio',
                          hintText: 'Psicología',
                          controller: _departmentController,
                          prefixIcon: const Icon(Icons.school_outlined, size: 20, color: MindColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email field
                      MindInputField(
                        label: 'Correo institucional o personal',
                        hintText: 'camila.soto@uc.cl',
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
                            GestureDetector(
                              onTap: _showPasswordResetDialog,
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: MindTypography.labelSmall.copyWith(
                                  color: MindColors.primaryDark,
                                  fontWeight: FontWeight.w600,
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
    );
  }
}

