import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/auth/presentation/widgets/auth_segmented_switch.dart';

void main() {
  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      theme: MindTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('AuthSegmentedSwitch Widget Tests', () {
    testWidgets('renders both tabs and toggles between them', (tester) async {
      bool isLogin = true;

      await tester.pumpWidget(
        createWidgetUnderTest(
          StatefulBuilder(
            builder: (context, setState) {
              return AuthSegmentedSwitch(
                isLoginMode: isLogin,
                onChanged: (val) => setState(() => isLogin = val),
              );
            },
          ),
        ),
      );

      expect(find.text('Iniciar sesión'), findsOneWidget);
      expect(find.text('Registrarse'), findsOneWidget);

      // Tap on Registrarse
      await tester.tap(find.text('Registrarse'));
      await tester.pumpAndSettle();

      expect(isLogin, isFalse);

      // Tap on Iniciar sesión
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pumpAndSettle();

      expect(isLogin, isTrue);
    });
  });
}

