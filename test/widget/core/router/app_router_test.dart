import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/app.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/models/user_model.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('AppRouter renders initial tab (Inicio) when authenticated and switches tabs preserving state', (tester) async {
    final fakeDataSource = FakeAuthDataSource(
      UserModel(
        uid: 'test_uid',
        email: 'camila.soto@uc.cl',
        displayName: 'Camila Soto',
        emailVerified: true,
        createdAtMillis: DateTime.now().millisecondsSinceEpoch,
      ),
    );
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

    // Verify initial tab is Inicio
    expect(find.text('¡Hola, Camila! 🌿'), findsOneWidget);
    expect(find.text('Tu estado de ánimo'), findsOneWidget);

    // Switch to Bienestar tab
    await tester.tap(find.text('Bienestar'));
    await tester.pumpAndSettle();

    expect(find.text('Tu espacio de bienestar ✨'), findsOneWidget);
    expect(find.text('SANCTUARY MODE'), findsOneWidget);

    // Switch to Agenda tab
    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();

    expect(find.text('Mi Agenda consciente'), findsOneWidget);
    expect(find.text('Ritmo en equilibrio'), findsOneWidget);

    // Switch to Perfil tab
    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();

    expect(find.text('Camila Soto'), findsOneWidget);
    expect(find.text('Línea de Apoyo Psicológico'), findsOneWidget);

    // Switch back to Inicio and verify state is maintained
    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();

    expect(find.text('¡Hola, Camila! 🌿'), findsOneWidget);
  });
}
