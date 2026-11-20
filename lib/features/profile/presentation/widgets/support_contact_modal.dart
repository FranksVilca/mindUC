import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/institutional_support_contact.dart';

/// Modal compasivo de contención institucional que despliega el anexo confidencial de apoyo psicológico.
class SupportContactModal extends StatelessWidget {
  final InstitutionalSupportContact contact;
  final VoidCallback? onCallNow;

  const SupportContactModal({
    super.key,
    required this.contact,
    this.onCallNow,
  });

  /// Muestra el modal en un diálogo centrado y compasivo.
  static Future<void> show({
    required BuildContext context,
    required InstitutionalSupportContact contact,
    VoidCallback? onCallNow,
  }) {
    return showDialog(
      context: context,
      builder: (context) => SupportContactModal(
        contact: contact,
        onCallNow: onCallNow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono en círculo verde salvia
            Container(
              width: 56.0,
              height: 56.0,
              decoration: const BoxDecoration(
                color: Color(0xFFE2EFE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: Color(0xFF2C5E47),
                size: 28.0,
              ),
            ),
            const SizedBox(height: 16.0),

            // Título
            Text(
              contact.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: MindColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6.0),

            // Subtítulo / Disponibilidad
            Text(
              contact.availability,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
                color: MindColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18.0),

            // Tarjeta de números y anexo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAF7),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFE0EFE5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Anexo directo:',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: MindColors.textSecondary,
                        ),
                      ),
                      Text(
                        contact.extensionNumber,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2C5E47),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Teléfono de red:',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: MindColors.textSecondary,
                        ),
                      ),
                      Text(
                        contact.phoneNumber,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: MindColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            const Text(
              'Esta llamada no tiene costo y tus datos están resguardados bajo secreto profesional universitario.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: MindColors.textTertiary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20.0),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2C5E47),
                      side: const BorderSide(color: Color(0xFFBCE3CB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: contact.extensionNumber));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Anexo copiado al portapapeles (*4000)'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      'Copiar anexo',
                      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF385C4B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCallNow?.call();
                    },
                    child: const Text(
                      'Llamar ahora',
                      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

