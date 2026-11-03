import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/app.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  group('GoRouter Auth Redirect Tests', () {
    testWidgets('redirects unauthenticated user to /auth (WelcomeAuthScreen)', (tester) async {
      final fakeDataSource = FakeAuthDataSource(null);
      final authRepo = AuthRepositoryImpl(fakeDataSource: fakeDataSource);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepo),
          ],
          child: const MindApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Should be on WelcomeAuthScreen
      expect(find.text('Encuentra tu centro en el ritmo universitario'), findsOneWidget);
      expect(find.text('Ingresar a mi espacio'), findsOneWidget);
      expect(find.text('¡Hola, Camila! 🌿'), findsNothing);
    });

    testWidgets('redirects to /home upon successful login', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final fakeDataSource = FakeAuthDataSource(null);
      final authRepo = AuthRepositoryImpl(fakeDataSource: fakeDataSource);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepo),
          ],
          child: const MindApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on login button
      await tester.ensureVisible(find.text('Ingresar a mi espacio'));
      await tester.tap(find.text('Ingresar a mi espacio'));
      await tester.pumpAndSettle();

      // Should now be on HomeScreen
      expect(find.text('¡Hola, Camila! 🌿'), findsOneWidget);
      expect(find.text('Tu estado de ánimo'), findsOneWidget);
    });
  });
}
