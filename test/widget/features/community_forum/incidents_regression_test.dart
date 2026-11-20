import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/community_forum/data/datasources/local_community_datasource.dart';
import 'package:minduc/features/community_forum/domain/entities/community_avatar.dart';
import 'package:minduc/features/community_forum/domain/entities/community_mood_category.dart';
import 'package:minduc/features/community_forum/domain/entities/community_post.dart';
import 'package:minduc/features/community_forum/presentation/widgets/community_post_create_modal.dart';
import 'package:minduc/features/relaxation/domain/entities/relaxation_step.dart';
import 'package:minduc/features/relaxation/presentation/widgets/relaxation_body_visualizer.dart';
import 'package:minduc/features/relaxation/presentation/widgets/relaxation_summary_dialog.dart';

void main() {
  group('Incidents Regression Tests', () {
    testWidgets('Incidente 1: RelaxationBodyVisualizer step 5 long direction does not overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const testStep = RelaxationStep(
        stepNumber: 5,
        title: 'Rotación sutil y fluida',
        instruction: 'Mueve suavemente el mentón hacia el pecho.',
        ergonomicTip: 'Mantén los hombros relajados.',
        durationSeconds: 30,
        bodyPartFocus: 'Cuello completo y trapecios',
        movementDirection: 'Semicírculos suaves de hombro a hombro',
        visualType: RelaxationVisualType.neckMobility,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: RelaxationBodyVisualizer(
                  step: testStep,
                  remainingSeconds: 30,
                  isPlaying: true,
                  accentColor: Color(0xFF6B8E7B),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Dirección: Semicírculos suaves de hombro a hombro'), findsOneWidget);
    });

    testWidgets('Incidente 2: RelaxationSummaryDialog metrics row does not overflow with long title',
        (tester) async {
      tester.view.physicalSize = const Size(320, 568); // Dispositivo angosto
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RelaxationSummaryDialog(
              activityName: 'Estiramiento de cuello',
              totalSeconds: 180,
              stepsCount: 5,
              onReturn: () {},
              onRepeat: () {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Estiramiento de cuello'), findsOneWidget);
      expect(find.text('3 min'), findsOneWidget);
      expect(find.text('5 de 5'), findsOneWidget);
    });

    testWidgets('Incidente 3: CommunityPostCreateModal alias row does not overflow with @CantoSuave',
        (tester) async {
      tester.view.physicalSize = const Size(320, 568); // Dispositivo angosto
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommunityPostCreateModal(
              onPublish: (alias, role, avatar, faculty, content, tags, mood) {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Compartir reflexión anónima'), findsOneWidget);
    });

    test('Incidente 4: LocalCommunityDataSource persists posts across repository recreations and user changes',
        () async {
      LocalCommunityDataSource.resetForTesting();

      final localDs1 = LocalCommunityDataSource();
      final post1 = CommunityPost(
        id: 'post-user-test-1',
        authorAlias: '@CantoSuave',
        authorRole: 'Brizna Serena',
        avatar: CommunityAvatar.sprout,
        faculty: 'Educación',
        timeAgo: 'Justo ahora',
        tags: const ['• Reflexión'],
        content: 'Un mensaje consciente para la comunidad UC',
        moodCategory: CommunityMoodCategory.habitoSaludable,
        createdAt: DateTime.now(),
      );

      await localDs1.savePost(post1);
      final initialList = await localDs1.getPosts();
      expect(initialList.any((p) => p.id == 'post-user-test-1'), isTrue);

      // Simular cambio de usuario o recreación de repositorio
      final localDs2 = LocalCommunityDataSource();
      final persistedList = await localDs2.getPosts();

      expect(persistedList.any((p) => p.id == 'post-user-test-1'), isTrue);
      expect(persistedList.firstWhere((p) => p.id == 'post-user-test-1').content,
          'Un mensaje consciente para la comunidad UC');
    });
  });
}
