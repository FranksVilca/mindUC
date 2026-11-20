import 'package:flutter/material.dart';

/// Logotipo circular oficial de mindUC.
/// Muestra el emblema con el cerebro y los brotes botánicos representativo de la identidad de la app.
class MindAppLogo extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const MindAppLogo({
    super.key,
    this.size = 32.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cacheDim = (size * 2).round();
    final Widget logoWidget = ClipOval(
      child: Image.asset(
        'assets/icons/app_logo.png',
        width: size,
        height: size,
        cacheWidth: cacheDim > 0 ? cacheDim : null,
        cacheHeight: cacheDim > 0 ? cacheDim : null,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F3EE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.spa_rounded,
              size: size * 0.55,
              color: const Color(0xFF2E6347),
            ),
          );
        },
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: logoWidget,
      );
    }

    return logoWidget;
  }
}
