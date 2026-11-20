import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../auth/presentation/widgets/avatar_selector_row.dart';
import '../../domain/entities/user_profile.dart';

/// Modal para editar datos personales y configuración de perfil del estudiante.
class ProfileSettingsModal extends StatefulWidget {
  final UserProfile user;
  final Future<void> Function(
    String fullName,
    String career,
    String email, [
    String? avatarUrl,
  ]) onSave;

  const ProfileSettingsModal({
    super.key,
    required this.user,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required UserProfile user,
    required Future<void> Function(
      String fullName,
      String career,
      String email, [
      String? avatarUrl,
    ]) onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ProfileSettingsModal(
          user: user,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<ProfileSettingsModal> createState() => _ProfileSettingsModalState();
}

class _ProfileSettingsModalState extends State<ProfileSettingsModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _careerController;
  late final TextEditingController _emailController;
  late String _selectedAvatarId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _careerController = TextEditingController(text: widget.user.career);
    _emailController = TextEditingController(text: widget.user.universityEmail);
    _selectedAvatarId = widget.user.avatarUrl ?? 'panda';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _careerController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await widget.onSave(
        _nameController.text.trim(),
        _careerController.text.trim(),
        _emailController.text.trim(),
        _selectedAvatarId,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de arrastre superior
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cabecera del modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Configuración de Perfil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: MindColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Actualiza tus datos personales e institucionales',
                          style: TextStyle(
                            fontSize: 12,
                            color: MindColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    splashRadius: 18,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Selector de Avatar compañero
              const Text(
                'Avatar compañero',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MindColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              AvatarSelectorRow(
                selectedAvatarId: _selectedAvatarId,
                onAvatarSelected: (avatar) => setState(() => _selectedAvatarId = avatar.id),
              ),
              const SizedBox(height: 18),

              // Campo: Nombre Completo
              const Text(
                'Nombre completo',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MindColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                key: const Key('profile_settings_name_input'),
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu nombre y apellido',
                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                  filled: true,
                  fillColor: MindColors.surfaceSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: MindColors.primaryDark,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'El nombre completo es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo: Carrera / Programa
              const Text(
                'Carrera o Departamento académico',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MindColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                key: const Key('profile_settings_career_input'),
                controller: _careerController,
                decoration: InputDecoration(
                  hintText: 'Ej. Psicología, Ingeniería, Medicina...',
                  prefixIcon: const Icon(Icons.school_outlined, size: 20),
                  filled: true,
                  fillColor: MindColors.surfaceSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: MindColors.primaryDark,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'La carrera o departamento es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo: Correo Institucional
              const Text(
                'Correo electrónico universitario',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MindColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                key: const Key('profile_settings_email_input'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'estudiante@uc.cl',
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  filled: true,
                  fillColor: MindColors.surfaceSubtle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: MindColors.primaryDark,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'El correo electrónico es obligatorio';
                  }
                  if (!val.contains('@') || !val.contains('.')) {
                    return 'Por favor ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botón Guardar cambios
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  key: const Key('profile_settings_save_btn'),
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MindColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Guardar cambios',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
