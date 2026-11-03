import 'package:flutter/material.dart';
import '../../theme/mind_colors.dart';
import '../../theme/mind_radii.dart';
import '../../theme/mind_typography.dart';

/// Campo de texto sereno oficial de mindUC con bordes redondeados y soporte para iconos.
class MindInputField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const MindInputField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: MindTypography.labelLarge.copyWith(
              color: MindColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          style: MindTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: MindTypography.bodyMedium.copyWith(color: MindColors.textTertiary),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: MindColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            border: const OutlineInputBorder(
              borderRadius: MindRadii.inputRadius,
              borderSide: BorderSide(color: MindColors.divider, width: 1.2),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: MindRadii.inputRadius,
              borderSide: BorderSide(color: MindColors.divider, width: 1.2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: MindRadii.inputRadius,
              borderSide: BorderSide(color: MindColors.primary, width: 1.8),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: MindRadii.inputRadius,
              borderSide: BorderSide(color: MindColors.error, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
