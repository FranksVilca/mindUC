import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/mind_colors.dart';
import 'mind_app_bar.dart';
import 'mind_bottom_nav_bar.dart';

/// Contenedor principal que aloja el Shell de navegación persistente de 4 pestañas.
class MainShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  String _getSectionTitle(int index) {
    return switch (index) {
      0 => 'Inicio',
      1 => 'Bienestar',
      2 => 'Agenda',
      3 => 'Perfil',
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: MindColors.background,
      appBar: MindAppBar(
        title: _getSectionTitle(currentIndex),
      ),
      body: navigationShell,
      bottomNavigationBar: MindBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
