import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/focus_pomodoro/presentation/widgets/mini_soundscape_bar.dart';
import '../../theme/mind_colors.dart';
import 'mind_bottom_nav_bar.dart';

/// Contenedor principal que aloja el Shell de navegación persistente de 4 pestañas
/// y el mini reproductor ambiental persistente de Pomodoro cuando está activo.
class MainShellScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      backgroundColor: MindColors.background,
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniSoundscapeBar(),
          MindBottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ],
      ),
    );
  }
}
