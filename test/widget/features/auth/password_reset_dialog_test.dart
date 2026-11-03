import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/auth/presentation/widgets/password_reset_dialog.dart';

void main() {
  Widget createWidgetUnderTest({
    required Future<bool> Function(String) onSubmit,
  }) {
    return MaterialApp(
      theme: MindTheme.lightTheme,
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => PasswordResetDialog(
                  initialEmail: 'camila.soto@uc.cl',
                  onSubmit: onSubmit,
                ),
              );
            },
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
  }

  group('PasswordResetDialog Widget Tests', () {
    testWidgets('renders dialog elements and submits email', (tester) async {
      String submittedEmail = '';

      await tester.pumpWidget(
        createWidgetUnderTest(
          onSubmit: (email) async {
            submittedEmail = email;
            return true;
          },
        ),
      );

      // Open dialog
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      expect(find.text('Recuperar contraseña'), findsOneWidget);
      expect(find.text('camila.soto@uc.cl'), findsWidgets);

      // Submit
      await tester.tap(find.text('Enviar enlace de recuperación'));
      await tester.pumpAndSettle();

      expect(submittedEmail, equals('camila.soto@uc.cl'));
      expect(find.text('Entendido, volver'), findsOneWidget);
    });
  });
}
