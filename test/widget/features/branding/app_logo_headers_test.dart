import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/design_system/avatars/mind_user_avatar.dart';
import 'package:minduc/core/design_system/branding/mind_app_logo.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/agenda/presentation/widgets/agenda_header.dart';
import 'package:minduc/features/auth/presentation/screens/welcome_auth_screen.dart';
import 'package:minduc/features/breathing/presentation/widgets/breathing_header.dart';
import 'package:minduc/features/community_forum/presentation/widgets/community_header.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/pomodoro_header.dart';
import 'package:minduc/features/home/presentation/widgets/home_header.dart';
import 'package:minduc/features/personal_journal/presentation/widgets/journal_header.dart';
import 'package:minduc/features/profile/presentation/widgets/profile_header.dart';
import 'package:minduc/features/progress_gamification/presentation/widgets/progress_header.dart';
import 'package:minduc/features/wellness/presentation/widgets/wellness_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('App Logo & Header Layout Integration Tests', () {
    testWidgets('MindAppLogo renders circular image asset correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MindAppLogo(size: 40),
            ),
          ),
        ),
      );

      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('WelcomeAuthScreen renders app logo in hero emblem without top header', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: MindTheme.lightTheme,
            home: const WelcomeAuthScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.text('Espacio de Bienestar Estudiantil'), findsOneWidget);
    });

    testWidgets('HomeHeader displays logo on left, title in center, and profile on right', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: const Scaffold(
            body: HomeHeader(),
          ),
        ),
      );

      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.byType(MindUserAvatar), findsOneWidget);
    });

    testWidgets('ProfileHeader displays logo on left, title in center, and profile actions on right', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: const Scaffold(
            body: ProfileHeader(avatarUrl: 'panda'),
          ),
        ),
      );

      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.byType(MindUserAvatar), findsOneWidget);
    });

    testWidgets('AgendaHeader displays logo on left, title in center, and profile on right', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: const Scaffold(
            body: AgendaHeader(avatarUrl: 'koala'),
          ),
        ),
      );

      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.byType(MindUserAvatar), findsOneWidget);
    });

    testWidgets('WellnessHeader displays logo on left, title in center, and profile on right', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: const Scaffold(
            body: WellnessHeader(avatarUrl: 'crocodile'),
          ),
        ),
      );

      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Bienestar'), findsOneWidget);
      expect(find.byType(MindUserAvatar), findsOneWidget);
    });

    testWidgets('Secondary headers (Breathing, Community, Journal, Pomodoro, Progress) display logo on left', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: Scaffold(
            appBar: BreathingHeader(onBack: () {}, avatarUrl: 'panda'),
          ),
        ),
      );
      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.byType(MindUserAvatar), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: Scaffold(
            appBar: CommunityHeader(onBack: () {}, avatarUrl: 'koala'),
          ),
        ),
      );
      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.byType(MindUserAvatar), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: Scaffold(
            body: JournalHeader(onBack: () {}, avatarUrl: 'crocodile'),
          ),
        ),
      );
      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.byType(MindUserAvatar), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: Scaffold(
            body: PomodoroHeader(onBack: () {}),
          ),
        ),
      );
      expect(find.byType(MindAppLogo), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: Scaffold(
            appBar: ProgressHeader(onBack: () {}, avatarUrl: 'panda'),
          ),
        ),
      );
      expect(find.byType(MindAppLogo), findsOneWidget);
      expect(find.byType(MindUserAvatar), findsOneWidget);
    });
  });
}
