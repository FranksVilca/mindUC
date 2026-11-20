import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/presentation/widgets/avatar_selector_row.dart';

void main() {
  testWidgets('AvatarSelectorRow displays all 3 animals with emojis and names', (tester) async {
    String selectedId = 'panda';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return AvatarSelectorRow(
                selectedAvatarId: selectedId,
                onAvatarSelected: (avatar) {
                  setState(() => selectedId = avatar.id);
                },
              );
            },
          ),
        ),
      ),
    );

    // Header and description
    expect(find.text('Elige tu avatar de perfil'), findsOneWidget);
    expect(find.text('3 animales'), findsOneWidget);

    // Emojis
    expect(find.text('🐼'), findsOneWidget);
    expect(find.text('🐨'), findsOneWidget);
    expect(find.text('🐯'), findsOneWidget);

    // Animal names
    expect(find.text('Oso panda'), findsOneWidget);
    expect(find.text('Koala'), findsOneWidget);
    expect(find.text('Tigre'), findsOneWidget);

    // Keys
    expect(find.byKey(const Key('avatar_choice_panda')), findsOneWidget);
    expect(find.byKey(const Key('avatar_choice_koala')), findsOneWidget);
    expect(find.byKey(const Key('avatar_choice_tiger')), findsOneWidget);

    // Selection indicators (checkmark icon should be present for selected)
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    // Tap on Koala
    await tester.tap(find.byKey(const Key('avatar_choice_koala')));
    await tester.pumpAndSettle();

    expect(selectedId, 'koala');
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    // Tap on Tigre
    await tester.tap(find.byKey(const Key('avatar_choice_tiger')));
    await tester.pumpAndSettle();

    expect(selectedId, 'tiger');
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });
}
