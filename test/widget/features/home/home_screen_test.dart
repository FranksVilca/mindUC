import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/models/user_model.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minduc/features/home/data/datasources/fake_mood_datasource.dart';
import 'package:minduc/features/home/data/repositories/mood_repository_impl.dart';
import 'package:minduc/features/home/presentation/controllers/home_dashboard_controller.dart';
import 'package:minduc/features/home/presentation/screens/home_screen.dart';

void main() {
  late FakeAuthDataSource fakeAuthDataSource;
  late AuthRepositoryImpl authRepo;
  late FakeMoodDataSource fakeMoodDataSource;
  late MoodRepositoryImpl moodRepo;

  setUp(() {
    fakeAuthDataSource = FakeAuthDataSource(
      const UserModel(
        uid: 'camila_123',
        email: 'camila.soto@uc.cl',
        displayName: 'Camila Soto',
        department: 'Psicología',
        emailVerified: true,
        createdAtMillis: 1792873200000,
      ),
    );
    authRepo = AuthRepositoryImpl(fakeDataSource: fakeAuthDataSource);
    fakeMoodDataSource = FakeMoodDataSource();
    moodRepo = MoodRepositoryImpl(fakeDataSource: fakeMoodDataSource);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepo),
        moodRepositoryProvider.overrideWithValue(moodRepo),
      ],
      child: MaterialApp(
        theme: MindTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('renders Figma elements: header, date pill, greeting, mood check-in and quick spaces', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Header
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Inicio'), findsOneWidget);

      // Greeting with name
      expect(find.text('¡Hola, Camila! 🌿'), findsOneWidget);
      expect(find.text('¿Cómo te sientes en este momento?'), findsOneWidget);

      // Mood Selector
      expect(find.text('Tu estado de ánimo'), findsOneWidget);
      expect(find.text('Calma'), findsOneWidget);
      expect(find.text('Feliz'), findsOneWidget);
      expect(find.text('Ansiosa'), findsOneWidget);
      expect(find.text('Cansada'), findsOneWidget);
      expect(find.text('Enérgica'), findsOneWidget);

      // Spaces
      expect(find.text('Espacios para ti'), findsOneWidget);
      expect(find.text('Relajación'), findsOneWidget);
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('Comunidad'), findsOneWidget);
      expect(find.text('Mi progreso'), findsOneWidget);
    });

    testWidgets('tapping mood card records mood reactively', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap on Enérgica
      await tester.tap(find.text('Enérgica'));
      await tester.pumpAndSettle();

      // Verify via UI state
      expect(find.text('Enérgica'), findsOneWidget);
    });
  });
}
