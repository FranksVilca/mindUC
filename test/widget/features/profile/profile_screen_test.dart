import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/models/user_model.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/auth/domain/entities/user_entity.dart';
import 'package:minduc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minduc/features/profile/data/datasources/local_profile_datasource.dart';
import 'package:minduc/features/profile/presentation/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LocalProfileDataSource.clearProfiles();
    FakeAuthDataSource.clearAccounts();
  });

  tearDown(() {
    LocalProfileDataSource.clearProfiles();
    FakeAuthDataSource.clearAccounts();
  });

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Widget createScreen({UserEntity? user}) {
    final authUser = user ??
        UserEntity(
          id: 'camila_123',
          email: 'camila.soto@uc.cl',
          displayName: 'Camila Soto',
          department: 'Psicología',
          isEmailVerified: true,
          isAnonymous: false,
          createdAt: DateTime(2024, 1, 1),
        );

    final authRepo = AuthRepositoryImpl(
      fakeDataSource: FakeAuthDataSource(
        UserModel(
          uid: authUser.id,
          email: authUser.email,
          displayName: authUser.displayName,
          department: authUser.department,
          emailVerified: authUser.isEmailVerified,
          createdAtMillis: authUser.createdAt.millisecondsSinceEpoch,
        ),
      ),
    );

    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepo),
      ],
      child: const MaterialApp(
        home: ProfileScreen(),
      ),
    );
  }

  group('ProfileScreen Full Integration Tests', () {
    testWidgets('renders all screen components according to Figma design', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // 1. Header
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

      // 2. Student identity card
      expect(find.text('Camila Soto'), findsOneWidget);
      expect(find.text('Psicología'), findsOneWidget);
      expect(find.text('camila.soto@uc.cl'), findsOneWidget);
      expect(find.byKey(const Key('profile_presence_dot')), findsOneWidget);

      // 3. Wellness preferences
      expect(find.text('PREFERENCIAS DE BIENESTAR'), findsOneWidget);
      expect(find.text('Sonido ambiental predeterminado'), findsOneWidget);
      expect(find.text('Lluvia suave en el bosque'), findsOneWidget);
      expect(find.text('Técnica de respiración favorita'), findsOneWidget);
      expect(find.text('Caja 4–4–4'), findsOneWidget);
      expect(find.text('Recordatorios conscientes'), findsOneWidget);
      expect(find.byKey(const Key('conscious_reminders_switch')), findsOneWidget);

      // 4. Institutional support
      expect(find.text('SOPORTE INSTITUCIONAL'), findsOneWidget);
      expect(find.text('Línea de Apoyo Psicológico'), findsOneWidget);
      expect(find.text('Anexo universitario confidencial'), findsOneWidget);
      expect(find.byKey(const Key('institutional_call_button')), findsOneWidget);

      // 5. Logout button
      expect(find.text('Cerrar sesión en este dispositivo'), findsOneWidget);
    });

    testWidgets('renders distinct User B identity dynamically without hardcoded data', (tester) async {
      configureViewport(tester);
      final userB = UserEntity(
        id: 'usr_rodrigo_456',
        email: 'rodrigo.morales@uc.cl',
        displayName: 'Rodrigo Morales',
        department: 'Medicina',
        isEmailVerified: true,
        isAnonymous: false,
        createdAt: DateTime(2024, 2, 1),
      );

      await tester.pumpWidget(createScreen(user: userB));
      await tester.pumpAndSettle();

      expect(find.text('Rodrigo Morales'), findsOneWidget);
      expect(find.text('Medicina'), findsOneWidget);
      expect(find.text('rodrigo.morales@uc.cl'), findsOneWidget);
      expect(find.text('Camila Soto'), findsNothing);
    });

    testWidgets('toggles conscious reminders switch and updates reactively', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      final switchFinder = find.byKey(const Key('conscious_reminders_switch'));
      expect(switchFinder, findsOneWidget);

      // Initial state is true
      Switch switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, isTrue);

      // Toggle switch
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // State is now false
      switchWidget = tester.widget<Switch>(switchFinder);
      expect(switchWidget.value, isFalse);
    });

    testWidgets('opens ambient sound modal and selects a different sound', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      expect(find.text('Lluvia suave en el bosque'), findsOneWidget);

      // Tap on ambient sound preference
      await tester.tap(find.text('Sonido ambiental predeterminado'));
      await tester.pumpAndSettle();

      // Modal options visible
      expect(find.text('Bosque al atardecer'), findsOneWidget);

      // Select Bosque al atardecer
      await tester.tap(find.text('Bosque al atardecer'));
      await tester.pumpAndSettle();

      // Modal closes and screen updates
      expect(find.text('Bosque al atardecer'), findsOneWidget);
    });

    testWidgets('opens support contact modal on Llamar tap', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('institutional_call_button')));
      await tester.pumpAndSettle();

      expect(find.text('*4000'), findsOneWidget);
      expect(find.text('+56 9 1234 5678'), findsOneWidget);
      expect(find.text('Copiar anexo'), findsOneWidget);
    });

    testWidgets('opens logout dialog when logout button is pressed', (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('profile_logout_button')));
      await tester.pumpAndSettle();

      expect(find.text('¿Cerrar sesión en este dispositivo?'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Cerrar sesión'), findsOneWidget);

      // Cancel dismissal
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('¿Cerrar sesión en este dispositivo?'), findsNothing);
      expect(find.text('Camila Soto'), findsOneWidget);
    });
  });
}
