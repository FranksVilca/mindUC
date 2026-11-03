import 'package:flutter/material.dart';
import '../../theme/mind_colors.dart';
import '../../theme/mind_radii.dart';
import '../../theme/mind_typography.dart';

enum MindButtonVariant { primary, secondary, outlined }

/// Botón píldora oficial de mindUC adaptado fielmente a los mockups de Figma.
class MindButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final MindButtonVariant variant;
  final double? width;
  final double height;

  const MindButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = MindButtonVariant.primary,
    this.width,
    this.height = 54.0,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    final Color bgColor = switch (variant) {
      MindButtonVariant.primary => MindColors.primary,
      MindButtonVariant.secondary => MindColors.primaryDark,
      MindButtonVariant.outlined => Colors.transparent,
    };

    final Color fgColor = switch (variant) {
      MindButtonVariant.outlined => MindColors.primary,
      _ => MindColors.onPrimary,
    };

    final BorderSide borderSide = variant == MindButtonVariant.outlined
        ? const BorderSide(color: MindColors.primary, width: 1.5)
        : BorderSide.none;

    final Widget content = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(fgColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: fgColor),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: MindTypography.labelLarge.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          disabledBackgroundColor: MindColors.primary.withAlpha(100),
          disabledForegroundColor: MindColors.onPrimary.withAlpha(180),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: MindRadii.buttonRadius,
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: content,
      ),
    );
  }
}
