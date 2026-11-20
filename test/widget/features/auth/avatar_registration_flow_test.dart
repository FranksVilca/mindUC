import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/models/user_model.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/auth/domain/entities/user_entity.dart';
import 'package:minduc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minduc/features/auth/presentation/screens/welcome_auth_screen.dart';
import 'package:minduc/features/profile/data/datasources/local_profile_datasource.dart';
import 'package:minduc/features/profile/presentation/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('Registration screen shows 3 animals and allows selecting Koala', (tester) async {
    configureViewport(tester);

    final fakeData = FakeAuthDataSource();
    final authRepo = AuthRepositoryImpl(fakeDataSource: fakeData);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepo),
        ],
        child: MaterialApp(
          theme: MindTheme.lightTheme,
          home: const WelcomeAuthScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Switch to Register mode
    await tester.tap(find.text('Registrarse'));
    await tester.pumpAndSettle();

    // Check all 3 animal avatars appear
    expect(find.text('Elige tu avatar de perfil'), findsOneWidget);
    expect(find.text('🐼'), findsOneWidget);
    expect(find.text('🐨'), findsOneWidget);
    expect(find.text('🐯'), findsOneWidget);
    expect(find.text('Oso panda'), findsOneWidget);
    expect(find.text('Koala'), findsOneWidget);
    expect(find.text('Tigre'), findsOneWidget);

    // Select Koala
    await tester.tap(find.byKey(const Key('avatar_choice_koala')));
    await tester.pumpAndSettle();

    // Fill form using form fields
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(4));

    await tester.enterText(fields.at(0), 'Martina Koala');
    await tester.enterText(fields.at(1), 'Biología');
    await tester.enterText(fields.at(2), 'martina@uc.cl');
    await tester.enterText(fields.at(3), 'secreto123');

    // Submit registration
    await tester.tap(find.text('Crear mi cuenta'));
    await tester.pumpAndSettle();

    // Verify current user registered with Koala avatar
    final currentUser = authRepo.currentUser;
    expect(currentUser, isNotNull);
    expect(currentUser!.displayName, 'Martina Koala');
    expect(currentUser.photoUrl, 'koala');
  });

  testWidgets('Registration screen defaults to Oso panda if none selected', (tester) async {
    configureViewport(tester);

    final fakeData = FakeAuthDataSource();
    final authRepo = AuthRepositoryImpl(fakeDataSource: fakeData);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepo),
        ],
        child: MaterialApp(
          theme: MindTheme.lightTheme,
          home: const WelcomeAuthScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Switch to Register mode
    await tester.tap(find.text('Registrarse'));
    await tester.pumpAndSettle();

    // Do NOT tap any avatar, leave default panda
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(4));

    await tester.enterText(fields.at(0), 'Pedro Panda');
    await tester.enterText(fields.at(1), 'Ingeniería');
    await tester.enterText(fields.at(2), 'pedro@uc.cl');
    await tester.enterText(fields.at(3), 'secreto123');

    // Submit registration
    await tester.tap(find.text('Crear mi cuenta'));
    await tester.pumpAndSettle();

    final currentUser = authRepo.currentUser;
    expect(currentUser, isNotNull);
    expect(currentUser!.displayName, 'Pedro Panda');
    expect(currentUser.photoUrl, 'panda');
  });

  testWidgets('ProfileScreen reflects selected animal avatar and allows changing to Cocodrilo', (tester) async {
    configureViewport(tester);

    final user = UserEntity(
      id: 'student_koala_01',
      email: 'koala@uc.cl',
      displayName: 'Estudiante Koala',
      department: 'Biología',
      photoUrl: 'koala',
      isEmailVerified: true,
      isAnonymous: false,
      createdAt: DateTime(2026, 11, 1),
    );

    final authRepo = AuthRepositoryImpl(
      fakeDataSource: FakeAuthDataSource(
        UserModel(
          uid: user.id,
          email: user.email,
          displayName: user.displayName,
          department: user.department,
          photoUrl: user.photoUrl,
          emailVerified: user.isEmailVerified,
          createdAtMillis: user.createdAt.millisecondsSinceEpoch,
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepo),
        ],
        child: const MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Koala emoji should be visible in student identity card
    expect(find.text('🐨'), findsWidgets);

    // Open ProfileSettingsModal
    await tester.tap(find.byTooltip('Configuración'));
    await tester.pumpAndSettle();

    // Change avatar to Tigre
    await tester.tap(find.byKey(const Key('avatar_choice_tiger')));
    await tester.pumpAndSettle();

    // Save changes
    await tester.tap(find.byKey(const Key('profile_settings_save_btn')));
    await tester.pumpAndSettle();

    // Verification: Tigre emoji is now reflected on screen
    expect(find.text('🐯'), findsWidgets);
    expect(find.text('Perfil actualizado correctamente 🌿'), findsOneWidget);
  });

  testWidgets('Avatar selection persists in local storage across sessions', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();
    final localDs = LocalProfileDataSource(preferences: sharedPrefs);

    // Initial state with crocodile avatar
    await localDs.updateUserProfile(
      userId: 'student_persist_test',
      fullName: 'Ana Cocodrilo',
      career: 'Derecho',
      universityEmail: 'ana@uc.cl',
      avatarUrl: 'crocodile',
    );

    // Simulate reopening app with fresh datasource instance
    LocalProfileDataSource.clearProfiles();
    final reopenedDs = LocalProfileDataSource(preferences: sharedPrefs);
    final loadedProfile = await reopenedDs.getProfileState(userId: 'student_persist_test');

    expect(loadedProfile.user.fullName, 'Ana Cocodrilo');
    expect(loadedProfile.user.avatarUrl, 'crocodile');
  });
}
