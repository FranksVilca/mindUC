import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_colors.dart';
import 'package:minduc/features/profile/domain/entities/user_profile.dart';
import 'package:minduc/features/profile/presentation/widgets/profile_header.dart';
import 'package:minduc/features/profile/presentation/widgets/student_identity_card.dart';

void main() {
  group('ProfileHeader Widget Tests', () {
    testWidgets('renders brand mindUC, title Perfil, and right action icons', (tester) async {
      bool settingsTapped = false;
      bool accountTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileHeader(
              onSettingsTap: () => settingsTapped = true,
              onAccountTap: () => accountTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pump();
      expect(settingsTapped, isTrue);

      await tester.tap(find.byIcon(Icons.person_rounded));
      await tester.pump();
      expect(accountTapped, isTrue);
    });
  });

  group('StudentIdentityCard Widget Tests', () {
    testWidgets('renders avatar with green presence dot, name, career and email', (tester) async {
      const user = UserProfile(
        id: 'test_student',
        fullName: 'Camila Soto',
        career: 'Psicología',
        universityEmail: 'camila.soto@uc.cl',
        isMindfulActive: true,
      );

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              backgroundColor: MindColors.background,
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: StudentIdentityCard(user: user),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Camila Soto'), findsOneWidget);
      expect(find.text('Psicología'), findsOneWidget);
      expect(find.text('camila.soto@uc.cl'), findsOneWidget);

      // Verify the presence dot indicator exists
      final presenceDot = find.byKey(const Key('profile_presence_dot'));
      expect(presenceDot, findsOneWidget);
    });
  });
}

