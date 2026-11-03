import 'package:flutter/material.dart';
import '../../theme/mind_colors.dart';
import '../../theme/mind_radii.dart';

/// Tarjeta serena oficial de mindUC con bordes redondeados de 22 dp
/// y soporte para los tintes semánticos de Figma.
class MindCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Border? border;
  final double? width;
  final double? height;

  const MindCard({
    super.key,
    required this.child,
    this.backgroundColor = MindColors.surface,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.border,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: MindRadii.cardRadius,
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: MindRadii.cardRadius,
        child: InkWell(
          borderRadius: MindRadii.cardRadius,
          onTap: onTap,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
