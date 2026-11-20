import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/domain/entities/user_entity.dart';
import 'package:minduc/features/auth/domain/repositories/auth_repository.dart';
import 'package:minduc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minduc/features/profile/data/datasources/local_profile_datasource.dart';
import 'package:minduc/features/profile/presentation/screens/profile_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuth;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LocalProfileDataSource.clearProfiles();
    mockAuth = MockAuthRepository();

    final testUser = UserEntity(
      id: 'student_diego_10',
      email: 'diego.martinez@uc.cl',
      displayName: 'Diego Martínez',
      department: 'Arquitectura',
      isEmailVerified: true,
      isAnonymous: false,
      createdAt: DateTime(2026, 11, 1),
    );

    when(() => mockAuth.currentUser).thenReturn(testUser);
    when(() => mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(testUser));
  });

  testWidgets('Opens ProfileSettingsModal, updates profile, and reflects on screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuth),
        ],
        child: const MaterialApp(
          home: ProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Comprobar datos iniciales en StudentIdentityCard
    expect(find.text('Diego Martínez'), findsOneWidget);
    expect(find.text('Arquitectura'), findsOneWidget);

    // Pulsar botón de configuración en ProfileHeader
    final settingsBtn = find.byTooltip('Configuración');
    expect(settingsBtn, findsOneWidget);
    await tester.tap(settingsBtn);
    await tester.pumpAndSettle();

    // Modal abierto: verificar presencia de campos
    expect(find.text('Configuración de Perfil'), findsOneWidget);
    final nameField = find.byKey(const Key('profile_settings_name_input'));
    final careerField = find.byKey(const Key('profile_settings_career_input'));
    final saveBtn = find.byKey(const Key('profile_settings_save_btn'));

    expect(nameField, findsOneWidget);
    expect(careerField, findsOneWidget);
    expect(saveBtn, findsOneWidget);

    // Editar nombre y carrera
    await tester.enterText(nameField, 'Diego A. Martínez Soto');
    await tester.enterText(careerField, 'Arquitectura & Urbanismo');
    await tester.pumpAndSettle();

    // Guardar cambios
    await tester.ensureVisible(saveBtn);
    await tester.tap(saveBtn);
    await tester.pumpAndSettle();

    // Modal cerrado y datos actualizados en la tarjeta
    expect(find.text('Diego A. Martínez Soto'), findsOneWidget);
    expect(find.text('Arquitectura & Urbanismo'), findsOneWidget);
    expect(find.text('Perfil actualizado correctamente 🌿'), findsOneWidget);
  });
}
