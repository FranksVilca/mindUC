import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/community_forum/domain/entities/community_mood_category.dart';
import 'package:minduc/features/community_forum/presentation/widgets/community_post_create_modal.dart';

void main() {
  group('CommunityPostCreateModal Widget Tests', () {
    testWidgets('renders identity protected notice, alias and form inputs',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    CommunityPostCreateModal.show(
                      context,
                      onPublish: (alias, role, avatar, faculty, content, tags, mood) {},
                    );
                  },
                  child: const Text('Abrir'),
                );
              },
            ),
          ),
        ),
      );

      // Abrir modal
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      expect(find.text('Compartir reflexión anónima'), findsOneWidget);
      expect(
        find.textContaining('Identidad protegida'),
        findsOneWidget,
      );
      expect(find.text('Publicar en comunidad'), findsOneWidget);
    });

    testWidgets('validates empty content before publishing', (tester) async {
      bool published = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    CommunityPostCreateModal.show(
                      context,
                      onPublish: (alias, role, avatar, faculty, content, tags, mood) {
                        published = true;
                      },
                    );
                  },
                  child: const Text('Abrir'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      // Intentar publicar con texto vacío
      await tester.tap(find.text('Publicar en comunidad'));
      await tester.pump();

      expect(published, isFalse);
      expect(
        find.text('Por favor escribe tu reflexión antes de publicar.'),
        findsOneWidget,
      );
    });

    testWidgets('publishes successfully with anonymous alias and no email leaks',
        (tester) async {
      String? publishedAlias;
      String? publishedContent;
      CommunityMoodCategory? publishedMood;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    CommunityPostCreateModal.show(
                      context,
                      onPublish: (alias, role, avatar, faculty, content, tags, mood) {
                        publishedAlias = alias;
                        publishedContent = content;
                        publishedMood = mood;
                      },
                    );
                  },
                  child: const Text('Abrir'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      // Ingresar texto reflexivo
      await tester.enterText(
        find.byType(TextField),
        'Hoy logré desconectar 15 minutos en el pasto y me ayudó mucho.',
      );
      await tester.pump();

      // Publicar
      await tester.tap(find.text('Publicar en comunidad'));
      await tester.pumpAndSettle();

      expect(publishedContent,
          'Hoy logré desconectar 15 minutos en el pasto y me ayudó mucho.');
      expect(publishedAlias, isNotNull);
      expect(publishedAlias!.startsWith('@'), isTrue);
      expect(publishedMood, isNotNull);
    });

    testWidgets('prevents publishing if personal email is included (Principle V)',
        (tester) async {
      bool published = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    CommunityPostCreateModal.show(
                      context,
                      onPublish: (alias, role, avatar, faculty, content, tags, mood) {
                        published = true;
                      },
                    );
                  },
                  child: const Text('Abrir'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      // Ingresar correo institucional
      await tester.enterText(
        find.byType(TextField),
        'Escríbanme a mi correo camila.soto@uc.cl para estudiar juntos.',
      );
      await tester.pump();

      await tester.tap(find.text('Publicar en comunidad'));
      await tester.pump();

      expect(published, isFalse);
      expect(
        find.textContaining('Por tu privacidad, no incluyas correos'),
        findsOneWidget,
      );
    });

    testWidgets('prevents publishing if text contains banned profanity words',
        (tester) async {
      bool published = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    CommunityPostCreateModal.show(
                      context,
                      onPublish: (alias, role, avatar, faculty, content, tags, mood) {
                        published = true;
                      },
                    );
                  },
                  child: const Text('Abrir'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      // Ingresar texto con palabra prohibida
      await tester.enterText(
        find.byType(TextField),
        'Este examen es una mierda total y odio todo',
      );
      await tester.pump();

      await tester.tap(find.text('Publicar en comunidad'));
      await tester.pump();

      expect(published, isFalse);
      expect(
        find.textContaining('Tu mensaje contiene palabras no permitidas ("mierda")'),
        findsOneWidget,
      );
    });
  });
}
