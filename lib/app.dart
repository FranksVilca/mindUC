import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/mind_theme.dart';

/// Widget raíz de la aplicación mindUC con enrutador declarativo y tema Material 3.
class MindApp extends ConsumerWidget {
  const MindApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'mindUC',
      debugShowCheckedModeBanner: false,
      theme: MindTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
