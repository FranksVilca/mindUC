import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/profile/domain/entities/institutional_support_contact.dart';
import 'package:minduc/features/profile/presentation/widgets/institutional_support_card.dart';
import 'package:minduc/features/profile/presentation/widgets/support_contact_modal.dart';

void main() {
  group('InstitutionalSupportCard & Modal Widget Tests', () {
    const contact = InstitutionalSupportContact(
      title: 'Línea de Apoyo Psicológico',
      description: 'Anexo universitario confidencial',
      phoneNumber: '+56 9 1234 5678',
      extensionNumber: '*4000',
    );

    testWidgets('InstitutionalSupportCard renders contact info and triggers onCallTap', (tester) async {
      bool callTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InstitutionalSupportCard(
              contact: contact,
              onCallTap: () => callTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('SOPORTE INSTITUCIONAL'), findsOneWidget);
      expect(find.text('Línea de Apoyo Psicológico'), findsOneWidget);
      expect(find.text('Anexo universitario confidencial'), findsOneWidget);
      expect(find.text('Llamar'), findsOneWidget);

      await tester.tap(find.byKey(const Key('institutional_call_button')));
      await tester.pump();
      expect(callTapped, isTrue);
    });

    testWidgets('SupportContactModal renders extension and phone details', (tester) async {
      bool callNowTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  SupportContactModal.show(
                    context: context,
                    contact: contact,
                    onCallNow: () => callNowTriggered = true,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Línea de Apoyo Psicológico'), findsOneWidget);
      expect(find.text('*4000'), findsOneWidget);
      expect(find.text('+56 9 1234 5678'), findsOneWidget);
      expect(find.text('Copiar anexo'), findsOneWidget);
      expect(find.text('Llamar ahora'), findsOneWidget);

      await tester.tap(find.text('Llamar ahora'));
      await tester.pumpAndSettle();

      expect(callNowTriggered, isTrue);
    });
  });
}

