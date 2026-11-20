import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/models/user_model.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/auth/presentation/controllers/auth_controller.dart';
import 'package:minduc/features/community_forum/data/datasources/local_community_datasource.dart';
import 'package:minduc/features/community_forum/data/repositories/local_community_repository_impl.dart';
import 'package:minduc/features/community_forum/domain/entities/community_avatar.dart';
import 'package:minduc/features/community_forum/domain/entities/community_mood_category.dart';
import 'package:minduc/features/community_forum/domain/entities/community_post.dart';
import 'package:minduc/features/community_forum/presentation/controllers/community_controller.dart';
import 'package:minduc/features/community_forum/presentation/screens/community_screen.dart';

void main() {
  late LocalCommunityDataSource dataSource;
  late LocalCommunityRepositoryImpl repository;
  late AuthRepositoryImpl authRepo;

  setUp(() {
    authRepo = AuthRepositoryImpl(
      fakeDataSource: FakeAuthDataSource(
        UserModel(
          uid: 'usr_carlos_123',
          email: 'carlos.munoz@uc.cl',
          displayName: 'Carlos Muñoz',
          department: 'Ingeniería',
          emailVerified: true,
          createdAtMillis: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );

    dataSource = LocalCommunityDataSource(
      initialPosts: [
        CommunityPost(
          id: 'test-post-1',
          authorAlias: '@LuzSerena',
          authorRole: 'Brote Sabio',
          avatar: CommunityAvatar.sprout,
          faculty: 'Educación',
          timeAgo: 'Hace 1h',
          tags: const ['• Pausa Consciente'],
          content: 'Hoy decidí caminar sin mirar el celular antes de mi clase. Me sentí presente 🌿',
          moodCategory: CommunityMoodCategory.habitoSaludable,
          supportCount: 10,
          calmCount: 5,
          insightCount: 2,
          hugCount: 0,
          commentCount: 0,
          comments: const [],
          emojiReactions: const {},
          createdAt: DateTime.now(),
        ),
      ],
    );

    repository = LocalCommunityRepositoryImpl(dataSource: dataSource);
  });

  Widget createWidgetUnderTest(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepo),
        communityRepositoryProvider.overrideWithValue(repository),
        communityControllerProvider.overrideWith(
          (ref) => CommunityNotifier(
            repository: repository,
            currentUserId: 'usr_carlos_123',
            currentUserName: 'Carlos Muñoz',
          ),
        ),
      ],
      child: const MaterialApp(
        home: CommunityScreen(),
      ),
    );
  }

  group('Community Forum Comments & Any Emoji Reactions Tests', () {
    testWidgets('Permite comentar una publicación mostrando nombre, avatar y actualizando reactivamente',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pumpAndSettle();

      expect(find.text('Hoy decidí caminar sin mirar el celular antes de mi clase. Me sentí presente 🌿'), findsOneWidget);

      // El contador de comentarios inicia en 0
      expect(find.text('0'), findsWidgets);

      // Tocar el botón de comentarios (💬)
      await tester.tap(find.text('💬'));
      await tester.pumpAndSettle();

      // Debe desplegarse la sección de comentarios
      expect(find.text('Comentarios (0)'), findsOneWidget);
      expect(find.textContaining('Aún no hay comentarios'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Escribir un comentario
      await tester.enterText(
        find.byType(TextField),
        '¡Qué hermosa práctica Carlos! Lo intentaré esta tarde en el campus.',
      );

      // Presionar el botón de enviar
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pumpAndSettle();

      // Verificar que el comentario aparece anónimo con la etiqueta Usuario anónimo y su texto
      expect(find.text('Usuario anónimo'), findsOneWidget);
      expect(find.text('Carlos Muñoz'), findsNothing);
      expect(
        find.text('¡Qué hermosa práctica Carlos! Lo intentaré esta tarde en el campus.'),
        findsOneWidget,
      );
      expect(find.text('Comentarios (1)'), findsOneWidget);
      expect(find.text('1'), findsWidgets);

      // Verificar persistencia en el repositorio (manteniendo authorId para moderación)
      final posts = await repository.getPosts();
      expect(posts.first.comments.length, 1);
      expect(posts.first.comments.first.authorName, 'Usuario anónimo');
      expect(posts.first.comments.first.authorId, 'usr_carlos_123');
      expect(posts.first.comments.first.content, '¡Qué hermosa práctica Carlos! Lo intentaré esta tarde en el campus.');
    });

    testWidgets('Permite reaccionar con cualquier emoji, evita duplicados y conmuta la reacción',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pumpAndSettle();

      // Abrir selector de emojis tocando el botón '+'
      await tester.tap(find.text('😊'));
      await tester.pumpAndSettle();

      expect(find.text('Elige tu reacción con emoji'), findsOneWidget);
      expect(find.text('✨'), findsOneWidget);

      // Seleccionar el emoji ✨
      await tester.tap(find.text('✨'));
      await tester.pumpAndSettle();

      // Verificar que el emoji ✨ aparece en la barra de reacciones con contador 1
      expect(find.text('✨'), findsOneWidget);
      expect(find.text('1'), findsWidgets);

      // Verificar en la persistencia del repositorio
      var posts = await repository.getPosts();
      expect(posts.first.emojiReactions['✨'], contains('usr_carlos_123'));
      expect(posts.first.emojiReactions['✨']!.length, 1);

      // Si el usuario toca de nuevo el emoji ✨, debe quitar su reacción (evita duplicados y permite toggle)
      await tester.tap(find.text('✨'));
      await tester.pumpAndSettle();

      posts = await repository.getPosts();
      expect(posts.first.emojiReactions['✨']?.contains('usr_carlos_123') ?? false, isFalse);
    });

    testWidgets('Primer toque en botón estándar (🌿) envía la reacción; segundo toque la retira',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pumpAndSettle();

      // Inicialmente calmCount es 5
      expect(find.text('5'), findsOneWidget);

      // Primer toque en el botón 🌿
      await tester.tap(find.text('🌿').first);
      await tester.pumpAndSettle();

      // Debe haber aumentado a 6
      expect(find.text('6'), findsOneWidget);
      var posts = await repository.getPosts(currentUserId: 'usr_carlos_123');
      expect(posts.first.calmCount, 6);
      expect(posts.first.hasReaction('calm'), isTrue);

      // Segundo toque en el mismo botón 🌿
      await tester.tap(find.text('🌿').first);
      await tester.pumpAndSettle();

      // Debe haber vuelto a 5 (se retira la reacción)
      expect(find.text('5'), findsOneWidget);
      posts = await repository.getPosts(currentUserId: 'usr_carlos_123');
      expect(posts.first.calmCount, 5);
      expect(posts.first.hasReaction('calm'), isFalse);
    });

    testWidgets('Permite escribir cualquier emoji libre desde el teclado en el modal selector',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(tester));
      await tester.pumpAndSettle();

      // Abrir modal de emoji
      await tester.tap(find.text('😊'));
      await tester.pumpAndSettle();

      // Escribir un emoji libre en el campo de texto
      final customField = find.widgetWithText(TextField, 'O escribe cualquier emoji de tu teclado...');
      expect(customField, findsOneWidget);
      await tester.enterText(customField, '🔥');

      await tester.tap(find.text('Reaccionar'));
      await tester.pumpAndSettle();

      // Verificar que aparece el emoji '🔥' en la barra
      expect(find.text('🔥'), findsOneWidget);
      final posts = await repository.getPosts();
      expect(posts.first.emojiReactions['🔥'], contains('usr_carlos_123'));
    });
  });
}
