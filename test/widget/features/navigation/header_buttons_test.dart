import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/breathing/presentation/widgets/breathing_header.dart';
import 'package:minduc/features/community_forum/presentation/widgets/community_header.dart';
import 'package:minduc/features/progress_gamification/presentation/widgets/progress_header.dart';

void main() {
  group('Header Navigation Buttons Tests', () {
    testWidgets('CommunityHeader back and profile buttons trigger callbacks', (tester) async {
      bool backTapped = false;
      bool profileTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: CommunityHeader(
              onBack: () => backTapped = true,
              onProfile: () => profileTapped = true,
            ),
          ),
        ),
      );

      final backBtn = find.byKey(const Key('community_header_back_btn'));
      expect(backBtn, findsOneWidget);
      await tester.tap(backBtn);
      expect(backTapped, isTrue);

      final profileBtn = find.byKey(const Key('community_header_profile_btn'));
      expect(profileBtn, findsOneWidget);
      await tester.tap(profileBtn);
      expect(profileTapped, isTrue);
    });

    testWidgets('ProgressHeader back and profile buttons trigger callbacks', (tester) async {
      bool backTapped = false;
      bool profileTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: ProgressHeader(
              onBack: () => backTapped = true,
              onProfile: () => profileTapped = true,
            ),
          ),
        ),
      );

      final backBtn = find.byKey(const Key('progress_header_back_btn'));
      expect(backBtn, findsOneWidget);
      await tester.tap(backBtn);
      expect(backTapped, isTrue);

      final profileBtn = find.byKey(const Key('progress_header_profile_btn'));
      expect(profileBtn, findsOneWidget);
      await tester.tap(profileBtn);
      expect(profileTapped, isTrue);
    });

    testWidgets('BreathingHeader back and profile buttons trigger callbacks', (tester) async {
      bool backTapped = false;
      bool profileTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: BreathingHeader(
              onBack: () => backTapped = true,
              onProfile: () => profileTapped = true,
            ),
          ),
        ),
      );

      final backBtn = find.byKey(const Key('breathing_header_back_btn'));
      expect(backBtn, findsOneWidget);
      await tester.tap(backBtn);
      expect(backTapped, isTrue);

      final profileBtn = find.byKey(const Key('breathing_header_profile_btn'));
      expect(profileBtn, findsOneWidget);
      await tester.tap(profileBtn);
      expect(profileTapped, isTrue);
    });
  });
}
