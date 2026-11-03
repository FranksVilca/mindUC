import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Botón estilizado para el cierre seguro de sesión en el dispositivo.
class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const LogoutButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.0,
      child: OutlinedButton(
        key: const Key('profile_logout_button'),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: MindColors.textPrimary,
          side: const BorderSide(
            color: Color(0xFFE2E2E2),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(MindColors.primary),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 19.0,
                    color: Color(0xFFD35D47),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Cerrar sesión en este dispositivo',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: MindColors.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
