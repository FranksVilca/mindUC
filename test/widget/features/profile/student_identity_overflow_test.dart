import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/theme/mind_theme.dart';
import 'package:minduc/features/profile/domain/entities/user_profile.dart';
import 'package:minduc/features/profile/presentation/widgets/student_identity_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('StudentIdentityCard handles very long student name without RenderFlex overflow', (tester) async {
    // Set a narrow mobile screen width to trigger overflow if unconstrained
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    const userWithSuperLongName = UserProfile(
      id: 'usr_long_name',
      fullName: 'Franks Javier Vilca Quispe de los Santos y Constantino de la Santísima Trinidad',
      career: 'Ingeniería Civil Industrial y de Sistemas de la Información',
      universityEmail: 'franksjaviervilcaquispe.delossantos@estudiante.uc.cl',
      avatarUrl: 'koala',
      isMindfulActive: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: MindTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: StudentIdentityCard(
              user: userWithSuperLongName,
              onEdit: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify no exception was thrown and the name is displayed
    expect(tester.takeException(), isNull);
    expect(find.byType(StudentIdentityCard), findsOneWidget);
    expect(find.textContaining('Franks Javier Vilca Quispe'), findsOneWidget);
  });
}
