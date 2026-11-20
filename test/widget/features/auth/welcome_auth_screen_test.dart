import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/design_system/branding/mind_app_logo.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/auth/presentation/screens/welcome_auth_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        theme: MindTheme.lightTheme,
        home: const WelcomeAuthScreen(),
      ),
    );
  }

  group('WelcomeAuthScreen Widget Tests', () {
    testWidgets('renders Figma elements: emblem, student badge, headline, form, button and tagline', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Central emblem
      expect(find.byType(MindAppLogo), findsOneWidget);

      // Badge
      expect(find.text('Espacio de Bienestar Estudiantil'), findsOneWidget);

      // Headline
      expect(find.text('Encuentra tu centro en el ritmo universitario'), findsOneWidget);

      // Subtitle
      expect(find.text('Un espacio seguro y compasivo para cultivar tus hábitos, claridad mental y paz interior.'), findsOneWidget);

      // Form fields in Login mode
      expect(find.text('Correo institucional o personal'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);

      // Button and footer tagline
      expect(find.text('Ingresar a mi espacio'), findsOneWidget);
      expect(find.text('• Ritmo guiado • Diario reflexivo • Calma activa •'), findsOneWidget);
    });

    testWidgets('toggles to register mode and displays name field and register button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initially in login mode
      expect(find.text('Ingresar a mi espacio'), findsOneWidget);
      expect(find.text('Nombre completo'), findsNothing);

      // Tap on Registrarse
      await tester.tap(find.text('Registrarse'));
      await tester.pumpAndSettle();

      // Should now show name and register button
      expect(find.text('Nombre completo'), findsOneWidget);
      expect(find.text('Crear mi cuenta'), findsOneWidget);
      expect(find.text('¿Olvidaste tu contraseña?'), findsNothing);
    });

    testWidgets('toggles password visibility when eye icon is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final eyeIconFinder = find.byIcon(Icons.visibility_outlined);
      expect(eyeIconFinder, findsOneWidget);
      await tester.ensureVisible(eyeIconFinder);

      await tester.tap(eyeIconFinder);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}
