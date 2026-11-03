import 'package:flutter/material.dart';
import '../../../../core/design_system/buttons/mind_button.dart';
import '../../../../core/design_system/inputs/mind_input_field.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_radii.dart';
import '../../../../core/theme/mind_typography.dart';

/// Diálogo sereno para recuperación de contraseña sin estrés.
class PasswordResetDialog extends StatefulWidget {
  final String initialEmail;
  final Future<bool> Function(String email) onSubmit;

  const PasswordResetDialog({
    super.key,
    required this.initialEmail,
    required this.onSubmit,
  });

  @override
  State<PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  late final TextEditingController _emailController;
  bool _isLoading = false;
  bool _isSent = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Por favor ingresa un correo válido.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await widget.onSubmit(email);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSent = success;
        if (!success) {
          _errorMessage = 'No se pudo enviar el correo de recuperación.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MindColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: MindRadii.cardRadius),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: MindColors.autocuidado,
                  child: Icon(Icons.mark_email_read_outlined, color: MindColors.primaryDark, size: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20, color: MindColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text('Recuperar contraseña', style: MindTypography.titleMedium),
            const SizedBox(height: 6),
            Text(
              _isSent
                  ? 'Te hemos enviado un enlace para restablecer tu contraseña con calma a tu bandeja de entrada.'
                  : 'Ingresa tu correo y te enviaremos un enlace seguro para restablecer tu acceso con calma.',
              style: MindTypography.bodyMedium,
            ),
            const SizedBox(height: 18),
            if (!_isSent) ...[
              MindInputField(
                label: 'Correo electrónico',
                hintText: 'camila.soto@uc.cl',
                controller: _emailController,
                prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20, color: MindColors.textSecondary),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: MindTypography.labelSmall.copyWith(color: MindColors.error),
                ),
              ],
              const SizedBox(height: 20),
              MindButton(
                text: 'Enviar enlace de recuperación',
                isLoading: _isLoading,
                width: double.infinity,
                onPressed: _submit,
              ),
            ] else ...[
              MindButton(
                text: 'Entendido, volver',
                width: double.infinity,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
