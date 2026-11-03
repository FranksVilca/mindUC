import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/design_system/navigation/mind_bottom_nav_bar.dart';
import 'package:minduc/core/theme/mind_theme.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      theme: MindTheme.lightTheme,
      home: Scaffold(bottomNavigationBar: child),
    );
  }

  group('MindBottomNavBar Widget Tests', () {
    testWidgets('renders all 4 tabs: Inicio, Bienestar, Agenda, Perfil', (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        createWidgetUnderTest(
          MindBottomNavBar(
            currentIndex: selectedIndex,
            onTap: (index) => selectedIndex = index,
          ),
        ),
      );

      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Bienestar'), findsOneWidget);
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when a destination is selected', (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        createWidgetUnderTest(
          StatefulBuilder(
            builder: (context, setState) {
              return MindBottomNavBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  setState(() => selectedIndex = index);
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Bienestar'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));

      await tester.tap(find.text('Agenda'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(2));
    });
  });
}

