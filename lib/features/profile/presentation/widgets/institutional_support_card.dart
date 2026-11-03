import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../domain/entities/institutional_support_contact.dart';

/// Tarjeta de acceso directo y confidencial a la Línea de Apoyo Psicológico institucional.
class InstitutionalSupportCard extends StatelessWidget {
  final InstitutionalSupportContact contact;
  final VoidCallback onCallTap;

  const InstitutionalSupportCard({
    super.key,
    required this.contact,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado de sección
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SOPORTE INSTITUCIONAL',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: MindColors.textSecondary,
                ),
              ),
              Icon(
                Icons.shield_outlined,
                size: 16.0,
                color: Color(0xFF2C5E47),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),

        // Tarjeta en verde pastel
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFDEEBE2),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: const Color(0xFFCEE0D4),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              // Círculo blanco con icono telefónico
              Container(
                width: 42.0,
                height: 42.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_in_talk_rounded,
                  color: Color(0xFF2C5E47),
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),

              // Textos de título y subtítulo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.title,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: MindColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      contact.description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: MindColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Botón píldora Llamar ↗
              ElevatedButton(
                key: const Key('institutional_call_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF385C4B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 8.0,
                  ),
                ),
                onPressed: onCallTap,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Llamar',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.0),
                    Icon(
                      Icons.north_east_rounded,
                      size: 14.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
