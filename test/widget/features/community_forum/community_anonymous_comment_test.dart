import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/community_forum/domain/entities/community_avatar.dart';
import 'package:minduc/features/community_forum/domain/entities/community_comment.dart';
import 'package:minduc/features/community_forum/domain/entities/community_mood_category.dart';
import 'package:minduc/features/community_forum/domain/entities/community_post.dart';
import 'package:minduc/features/community_forum/presentation/widgets/community_post_card.dart';

void main() {
  testWidgets('Comments are displayed anonymously hiding name and showing Usuario anónimo', (tester) async {
    final post = CommunityPost(
      id: 'post-anon-1',
      authorAlias: 'Estudiante Sereno',
      authorRole: 'Compañero UC',
      avatar: CommunityAvatar.sprout,
      faculty: 'Ingeniería',
      timeAgo: 'Hace 5m',
      tags: ['Reflexión'],
      content: 'Contenido reflexivo sobre la semana de exámenes.',
      moodCategory: CommunityMoodCategory.desahogoCalma,
      createdAt: DateTime.now(),
      comments: [
        CommunityComment(
          id: 'comm-1',
          postId: 'post-anon-1',
          authorId: 'user_maria_999',
          authorName: 'María Pérez González', // Nombre real en base de datos interna
          content: 'Ánimo, todos podemos lograrlo paso a paso.',
          createdAt: DateTime.now(),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CommunityPostCard(
              post: post,
              currentUserId: 'user_juan_123',
              currentUserName: 'Juan Carlos Soto',
              onReactionTap: (_) {},
            ),
          ),
        ),
      ),
    );

    // Expandir comentarios pulsando en el botón de comentarios
    final commentBtn = find.byKey(const Key('comment_toggle_button_post-anon-1'));
    expect(commentBtn, findsOneWidget);
    await tester.tap(commentBtn);
    await tester.pumpAndSettle();

    // Debe mostrar "Usuario anónimo"
    expect(find.text('Usuario anónimo'), findsOneWidget);

    // NO debe mostrar el nombre real del usuario en la interfaz
    expect(find.text('María Pérez González'), findsNothing);
    expect(find.text('Juan Carlos Soto'), findsNothing);

    // El placeholder del campo de texto debe indicar anonimato
    expect(find.text('Escribe un comentario anónimo...'), findsOneWidget);
  });
}
