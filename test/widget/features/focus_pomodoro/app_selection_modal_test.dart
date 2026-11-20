import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/focus_pomodoro/domain/entities/blocked_app.dart';
import 'package:minduc/features/focus_pomodoro/presentation/widgets/app_selection_modal.dart';

void main() {
  group('AppSelectionModal Widget Tests', () {
    testWidgets('renders modal header, duration options and app list with checkboxes',
        (tester) async {
      String? toggledAppId;
      bool? toggledValue;
      String? addedCustomApp;
      int? changedDuration;

      final apps = [
        const BlockedApp(
          id: 'instagram',
          name: 'Instagram',
          packageName: 'com.instagram.android',
          category: 'Redes sociales',
          isBlocked: true,
        ),
        const BlockedApp(
          id: 'tiktok',
          name: 'TikTok',
          packageName: 'com.zhiliaoapp.musically',
          category: 'Redes sociales',
          isBlocked: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSelectionModal(
              availableApps: apps,
              currentDurationMinutes: 25,
              onToggleApp: (id, val) {
                toggledAppId = id;
                toggledValue = val;
              },
              onAddCustomApp: (name) => addedCustomApp = name,
              onDurationChanged: (mins) => changedDuration = mins,
            ),
          ),
        ),
      );

      // Cabecera y textos
      expect(find.text('Seleccionar aplicaciones'), findsOneWidget);
      expect(find.text('Elige qué apps silenciar en tus sesiones'), findsOneWidget);
      expect(find.text('Período de bloqueo:'), findsOneWidget);
      expect(find.text('25 min (Pomodoro)'), findsOneWidget);
      expect(find.text('45 min'), findsOneWidget);

      // Lista de apps con Checkboxes
      expect(find.text('Instagram'), findsOneWidget);
      expect(find.text('TikTok'), findsOneWidget);
      expect(find.byType(Checkbox), findsNWidgets(2));

      // Tocar checkbox de TikTok para bloquearlo
      await tester.tap(find.text('TikTok'));
      await tester.pump();
      expect(toggledAppId, 'tiktok');
      expect(toggledValue, isTrue);

      // Cambiar duración a 45 min
      await tester.tap(find.text('45 min'));
      await tester.pump();
      expect(changedDuration, 45);

      // Abrir campo de app personalizada
      await tester.tap(find.text('Agregar otra app'));
      await tester.pumpAndSettle();

      expect(find.text('Agregar'), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, 'Discord');
      await tester.tap(find.text('Agregar'));
      await tester.pump();
      expect(addedCustomApp, 'Discord');
    });

    testWidgets('filters apps in search field', (tester) async {
      final apps = [
        const BlockedApp(
          id: 'instagram',
          name: 'Instagram',
          packageName: 'com.instagram.android',
          category: 'Redes sociales',
          isBlocked: true,
        ),
        const BlockedApp(
          id: 'netflix',
          name: 'Netflix',
          packageName: 'com.netflix.mediaclient',
          category: 'Entretenimiento',
          isBlocked: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSelectionModal(
              availableApps: apps,
              currentDurationMinutes: 25,
              onToggleApp: (_, __) {},
              onAddCustomApp: (_) {},
              onDurationChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Instagram'), findsOneWidget);
      expect(find.text('Netflix'), findsOneWidget);

      // Escribir en el buscador
      await tester.enterText(find.byType(TextField).first, 'Netf');
      await tester.pumpAndSettle();

      expect(find.text('Netflix'), findsOneWidget);
      expect(find.text('Instagram'), findsNothing);
    });

    testWidgets(
        'does not overflow with 56px bottom navigation inset or active keyboard',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      tester.view.padding = const FakeViewPadding(bottom: 56.0);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.view.resetPadding();
      });

      final apps = List.generate(
        10,
        (i) => BlockedApp(
          id: 'app_$i',
          name: 'App Distractora $i',
          packageName: 'com.app.$i',
          category: 'Redes',
          isBlocked: i.isEven,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => AppSelectionModal(
                        availableApps: apps,
                        currentDurationMinutes: 25,
                        onToggleApp: (_, __) {},
                        onAddCustomApp: (_) {},
                        onDurationChanged: (_) {},
                      ),
                    );
                  },
                  child: const Text('Open Modal'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Seleccionar aplicaciones'), findsOneWidget);
      expect(find.text('Período de bloqueo:'), findsOneWidget);
      expect(find.textContaining('Guardar preferencias'), findsOneWidget);

      // Tap on an app to select/toggle
      await tester.ensureVisible(find.text('App Distractora 1'));
      await tester.tap(find.text('App Distractora 1'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
