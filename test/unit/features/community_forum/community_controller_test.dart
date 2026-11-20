import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/community_forum/data/datasources/local_community_datasource.dart';
import 'package:minduc/features/community_forum/data/repositories/local_community_repository_impl.dart';
import 'package:minduc/features/community_forum/domain/entities/community_avatar.dart';
import 'package:minduc/features/community_forum/domain/entities/community_mood_category.dart';
import 'package:minduc/features/community_forum/domain/entities/embedded_card_data.dart';
import 'package:minduc/features/community_forum/presentation/controllers/community_controller.dart';

void main() {
  late LocalCommunityDataSource dataSource;
  late LocalCommunityRepositoryImpl repository;
  late CommunityNotifier notifier;

  setUp(() {
    LocalCommunityDataSource.resetForTesting();
    dataSource = LocalCommunityDataSource();
    repository = LocalCommunityRepositoryImpl(dataSource: dataSource);
    notifier = CommunityNotifier(repository: repository);
  });

  group('CommunityNotifier Unit Tests', () {
    test('initial state loads 3 Figma mock posts and sets filter to todo',
        () async {
      await Future<void>.delayed(Duration.zero);

      final state = notifier.state;
      expect(state.selectedFilter, CommunityMoodCategory.todo);
      expect(state.activeThreadCount, 3);
      expect(state.filteredPosts.length, 3);
      expect(state.allPosts.first.authorAlias, '@BúhoCurioso');
      expect(state.allPosts[1].authorAlias, '@BroteCalmo');
      expect(state.allPosts[2].authorAlias, '@LluviaSuave');
    });

    test('selectFilter updates filter and returns only matching posts',
        () async {
      await Future<void>.delayed(Duration.zero);

      // Filtrar por Estrés académico
      notifier.selectFilter(CommunityMoodCategory.estresAcademico);
      expect(
        notifier.state.selectedFilter,
        CommunityMoodCategory.estresAcademico,
      );
      expect(notifier.state.filteredPosts.length, 1);
      expect(notifier.state.filteredPosts.first.authorAlias, '@BúhoCurioso');

      // Filtrar por Hábito saludable
      notifier.selectFilter(CommunityMoodCategory.habitoSaludable);
      expect(notifier.state.filteredPosts.length, 1);
      expect(notifier.state.filteredPosts.first.authorAlias, '@BroteCalmo');

      // Volver a Todo
      notifier.selectFilter(CommunityMoodCategory.todo);
      expect(notifier.state.filteredPosts.length, 3);
    });

    test('toggleReaction updates reaction counts and user reaction set',
        () async {
      await Future<void>.delayed(Duration.zero);

      final initialSupport = notifier.state.allPosts.first.supportCount;
      expect(notifier.state.allPosts.first.hasReaction('support'), isFalse);

      // Reaccionar con 'support' al post 1
      await notifier.toggleReaction('post-1', 'support');

      final updatedPost = notifier.state.allPosts.first;
      expect(updatedPost.supportCount, initialSupport + 1);
      expect(updatedPost.hasReaction('support'), isTrue);

      // Retirar reacción
      await notifier.toggleReaction('post-1', 'support');
      final revertedPost = notifier.state.allPosts.first;
      expect(revertedPost.supportCount, initialSupport);
      expect(revertedPost.hasReaction('support'), isFalse);
    });

    test('createPost inserts new anonymous post at index 0', () async {
      await Future<void>.delayed(Duration.zero);

      await notifier.createPost(
        authorAlias: '@EstrellaSerena',
        authorRole: 'Luz Calma',
        avatar: CommunityAvatar.flower,
        faculty: 'Arquitectura',
        content:
            'Dibujar hoy al sol me ayudó a despejar la mente antes de la entrega final.',
        tags: ['• Hábito saludable', 'Creatividad'],
        moodCategory: CommunityMoodCategory.habitoSaludable,
      );

      expect(notifier.state.activeThreadCount, 4);
      expect(notifier.state.allPosts.first.authorAlias, '@EstrellaSerena');
      expect(notifier.state.allPosts.first.faculty, 'Arquitectura');
      expect(notifier.state.allPosts.first.authorRole, 'Luz Calma');
    });

    test('EmbeddedCardData correctly identifies card presence', () {
      const emptyCard =
          EmbeddedCardData(type: EmbeddedCardType.none, title: '');
      expect(emptyCard.hasCard, isFalse);

      const breathingCard = EmbeddedCardData(
        type: EmbeddedCardType.breathingPrompt,
        title: 'Guía 4-7-8',
        actionLabel: 'Probar',
      );
      expect(breathingCard.hasCard, isTrue);
    });
  });
}
