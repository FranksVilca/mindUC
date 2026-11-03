import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/models/user_model.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minduc/features/breathing/data/datasources/fake_breathing_datasource.dart';
import 'package:minduc/features/breathing/data/repositories/breathing_repository_impl.dart';
import 'package:minduc/features/breathing/presentation/controllers/breathing_session_controller.dart';
import 'package:minduc/features/breathing/presentation/screens/breathing_screen.dart';

void main() {
  group('BreathingScreen Full Integration Widget Tests', () {
    late FakeAuthDataSource fakeAuthDS;
    late AuthRepositoryImpl authRepo;
    late FakeBreathingDataSource fakeBreathingDS;
    late BreathingRepositoryImpl breathingRepo;

    setUp(() {
      fakeAuthDS = FakeAuthDataSource(
        const UserModel(
          uid: 'screen_test_user',
          email: 'user@uc.cl',
          displayName: 'Estudiante',
          emailVerified: true,
          createdAtMillis: 1792873200000,
        ),
      );
      authRepo = AuthRepositoryImpl(fakeDataSource: fakeAuthDS);
      fakeBreathingDS = FakeBreathingDataSource();
      breathingRepo = BreathingRepositoryImpl(fakeDataSource: fakeBreathingDS);
    });

    Widget createTestApp() {
      return ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepo),
          breathingRepositoryProvider.overrideWithValue(breathingRepo),
        ],
        child: const MaterialApp(
          home: BreathingScreen(),
        ),
      );
    }

    testWidgets('renders all screen components according to Figma design', (tester) async {
      await tester.pumpWidget(createTestApp());

      // 1. Header
      expect(find.text('Sesion Respiracion'), findsOneWidget);
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // 2. Technique selector
      expect(find.text('Respiración 4-4-4 (Caja)'), findsOneWidget);

      // 3. Progress card
      expect(find.text('Tiempo restante'), findsOneWidget);

      // 4. Visualizer
      expect(find.text('Inhala suave'), findsOneWidget);
      expect(find.text('4s'), findsOneWidget);
      expect(find.text('EXPANDE EL ABDOMEN'), findsOneWidget);

      // 5. Controls
      expect(find.text('Iniciar sesión'), findsOneWidget);

      // 6. Presets
      expect(find.text('10 min'), findsOneWidget);
    });

    testWidgets('tapping Iniciar sesión changes button to Pausar sesión', (tester) async {
      await tester.pumpWidget(createTestApp());

      expect(find.text('Iniciar sesión'), findsOneWidget);

      await tester.tap(find.text('Iniciar sesión'));
      await tester.pump();

      expect(find.text('Pausar sesión'), findsOneWidget);
    });

    testWidgets('tapping stop shows completion summary dialog with metrics', (tester) async {
      await tester.pumpWidget(createTestApp());

      // Start session
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pump();

      // Tap stop button
      await tester.tap(find.byIcon(Icons.stop));
      await tester.pumpAndSettle();

      // Verify completion dialog is shown
      expect(find.text('¡Pausa consciente completada! 🌿'), findsOneWidget);
      expect(find.text('Volver al inicio'), findsOneWidget);
      expect(find.text('Hacer otra pausa'), findsOneWidget);

      // Tap on Hacer otra pausa to dismiss and reset
      await tester.tap(find.text('Hacer otra pausa'));
      await tester.pumpAndSettle();

      expect(find.text('¡Pausa consciente completada! 🌿'), findsNothing);
      expect(find.text('Iniciar sesión'), findsOneWidget);
    });
  });
}
