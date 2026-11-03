import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/community_forum/domain/entities/community_avatar.dart';
import 'package:minduc/features/community_forum/domain/entities/community_mood_category.dart';
import 'package:minduc/features/community_forum/domain/entities/community_post.dart';
import 'package:minduc/features/community_forum/domain/entities/embedded_card_data.dart';
import 'package:minduc/features/community_forum/presentation/widgets/community_banner_card.dart';
import 'package:minduc/features/community_forum/presentation/widgets/community_post_card.dart';

void main() {
  group('CommunityBannerCard Widget Tests', () {
    testWidgets('renders safe space badges, title and protected identity notice',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommunityBannerCard(),
          ),
        ),
      );

      expect(find.text('ESPACIO SEGURO UC'), findsOneWidget);
      expect(find.text('Moderado con empatía'), findsOneWidget);
      expect(find.text('Comunidad UC Consciente'), findsOneWidget);
      expect(
        find.textContaining('Un espacio anónimo, seguro y libre de juicios'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Identidad protegida: todos los alias son ficticios'),
        findsOneWidget,
      );
    });
  });

  group('CommunityPostCard Widget Tests', () {
    testWidgets('renders author alias, role, faculty, tags, content and reactions',
        (tester) async {
      String? reactedKey;

      final post = CommunityPost(
        id: 'post-1',
        authorAlias: '@BúhoCurioso',
        authorRole: 'Búho Sereno',
        avatar: CommunityAvatar.moon,
        faculty: 'Ingeniería',
        timeAgo: 'Hace 2h',
        tags: const ['• Necesito desahogo', 'Exámenes'],
        content:
            'Siento que esta semana de exámenes parciales me está superando. Recordatorio: una nota no define nuestro valor.',
        moodCategory: CommunityMoodCategory.estresAcademico,
        embeddedCard: const EmbeddedCardData(
          type: EmbeddedCardType.insightNotice,
          title: '5 compañeros han tomado una pausa respiratoria tras leer esto.',
        ),
        supportCount: 42,
        calmCount: 28,
        insightCount: 9,
        commentCount: 14,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CommunityPostCard(
                post: post,
                onReactionTap: (key) => reactedKey = key,
              ),
            ),
          ),
        ),
      );

      expect(find.text('@BúhoCurioso'), findsOneWidget);
      expect(find.text('Búho Sereno'), findsOneWidget);
      expect(find.text('Ingeniería · Hace 2h'), findsOneWidget);
      expect(find.text('• Necesito desahogo'), findsOneWidget);
      expect(find.text('Exámenes'), findsOneWidget);
      expect(
        find.text(
          'Siento que esta semana de exámenes parciales me está superando. Recordatorio: una nota no define nuestro valor.',
        ),
        findsOneWidget,
      );

      // Tarjeta incrustada de insight
      expect(
        find.text('5 compañeros han tomado una pausa respiratoria tras leer esto.'),
        findsOneWidget,
      );

      // Reacciones
      expect(find.text('42'), findsOneWidget);
      expect(find.text('28'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);

      // Tocar reacción de calma
      await tester.tap(find.text('28'));
      await tester.pump();

      expect(reactedKey, 'calm');
    });

    testWidgets('renders breathing prompt embedded card with Probar button',
        (tester) async {
      bool actionTapped = false;

      final post = CommunityPost(
        id: 'post-2',
        authorAlias: '@BroteCalmo',
        authorRole: 'Brote Verde',
        avatar: CommunityAvatar.sprout,
        faculty: 'Medicina',
        timeAgo: 'Hace 4h',
        tags: const ['• Hábito saludable', 'Mindfulness'],
        content: 'Hice la pausa de respiración 4–7–8 y la diferencia fue increíble.',
        moodCategory: CommunityMoodCategory.habitoSaludable,
        embeddedCard: const EmbeddedCardData(
          type: EmbeddedCardType.breathingPrompt,
          title: 'Guía 4–7–8 recomendada',
          subtitle: '3 min · Sesión de calma',
          actionLabel: 'Probar',
        ),
        supportCount: 65,
        calmCount: 41,
        commentCount: 8,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CommunityPostCard(
                post: post,
                onReactionTap: (_) {},
                onEmbeddedActionTap: () => actionTapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Guía 4–7–8 recomendada'), findsOneWidget);
      expect(find.text('3 min · Sesión de calma'), findsOneWidget);
      expect(find.text('Probar'), findsOneWidget);

      await tester.tap(find.text('Probar'));
      await tester.pump();

      expect(actionTapped, isTrue);
    });
  });
}
