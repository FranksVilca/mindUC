import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/design_system/buttons/mind_button.dart';
import 'package:minduc/core/theme/mind_theme.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      theme: MindTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('MindButton Widget Tests', () {
    testWidgets('renders button text and triggers onPressed when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          MindButton(
            text: 'Comenzar (5 min)',
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Comenzar (5 min)'), findsOneWidget);
      await tester.tap(find.byType(MindButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('displays loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          MindButton(
            text: 'Guardar',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Guardar'), findsNothing);
    });

    testWidgets('renders disabled state when onPressed is null', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const MindButton(
            text: 'Deshabilitado',
            onPressed: null,
          ),
        ),
      );

      expect(find.text('Deshabilitado'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('renders leading icon when provided', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          MindButton(
            text: 'Ingresar a mi espacio',
            icon: Icons.notifications_none,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.notifications_none), findsOneWidget);
      expect(find.text('Ingresar a mi espacio'), findsOneWidget);
    });
  });
}
