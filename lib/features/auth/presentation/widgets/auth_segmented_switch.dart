import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import '../../../../core/theme/mind_typography.dart';

/// Selector segmentado animado oficial de mindUC para alternar entre
/// Iniciar sesión y Registrarse, idéntico al mockup de Figma.
class AuthSegmentedSwitch extends StatelessWidget {
  final bool isLoginMode;
  final ValueChanged<bool> onChanged;

  const AuthSegmentedSwitch({
    super.key,
    required this.isLoginMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE4),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Iniciar sesión',
              icon: Icons.login_rounded,
              isSelected: isLoginMode,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Registrarse',
              icon: Icons.person_add_alt_outlined,
              isSelected: !isLoginMode,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? MindColors.textPrimary : MindColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MindTypography.labelLarge.copyWith(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? MindColors.textPrimary : MindColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

