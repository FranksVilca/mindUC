import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/app.dart';

void main() {
  testWidgets('AppRouter renders initial tab (Inicio) and switches to other tabs preserving state', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MindApp(),
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
