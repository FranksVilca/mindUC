import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/home/presentation/widgets/date_pill.dart';
import 'package:minduc/features/home/presentation/widgets/home_header.dart';

void main() {
  group('HomeHeader and DatePill Widget Tests', () {
    testWidgets('HomeHeader renders logo, subtitle, bell and avatar', (tester) async {
      bool notificationTapped = false;
      bool avatarTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: Scaffold(
            body: HomeHeader(
              onNotificationPressed: () => notificationTapped = true,
              onAvatarPressed: () => avatarTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

      await tester.tap(find.byIcon(Icons.notifications_none_rounded));
      expect(notificationTapped, isTrue);

      await tester.tap(find.byType(CircleAvatar));
      expect(avatarTapped, isTrue);
    });

    testWidgets('DatePill renders calendar icon and formatted date text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MindTheme.lightTheme,
          home: const Scaffold(
            body: DatePill(formattedDate: 'Jueves, 24 de Octubre'),
          ),
        ),
      );

      expect(find.text('Jueves, 24 de Octubre'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });
  });
}

