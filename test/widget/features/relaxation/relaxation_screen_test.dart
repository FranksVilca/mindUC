import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:minduc/core/router/route_names.dart';
import 'package:minduc/features/relaxation/presentation/controllers/relaxation_controller.dart';
import 'package:minduc/features/relaxation/presentation/screens/relaxation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createScreen() {
    final router = GoRouter(
      initialLocation: AppRoutes.relaxation,
      routes: [
        GoRoute(
          path: AppRoutes.relaxation,
          builder: (context, state) => const RelaxationScreen(),
        ),
        GoRoute(
          path: AppRoutes.relaxationExercise,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Exercise Screen Mock')),
          ),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('RelaxationScreen Widget Tests', () {
    testWidgets('renders header, hero banner and all 4 official activities with benefits and badges',
        (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // 1. Cabecera
      expect(find.text('mindUC'), findsOneWidget);
      expect(find.text('Relajación y Pausas Activas'), findsOneWidget);

      // 2. Banner hero
      expect(find.text('Pausas Saludables UC ✨'), findsOneWidget);
      expect(find.text('Desconecta, estira y renueva tu cuerpo'), findsOneWidget);
      expect(find.text('0 de 4 hoy'), findsOneWidget);

      // 3. Actividades requeridas
      expect(find.text('Estiramiento de cuello'), findsOneWidget);
      expect(find.text('Estiramiento de espalda'), findsOneWidget);
      expect(find.text('Automasajes de mandíbula'), findsOneWidget);
      expect(find.text('Pausa visual inteligente'), findsOneWidget);

      // 4. Beneficios y duraciones
      expect(find.textContaining('Libera la rigidez acumulada en la base cervical'), findsOneWidget);
      expect(find.textContaining('Descomprime las vértebras lumbares y dorsales'), findsOneWidget);
      expect(find.textContaining('Disminuye la tensión en la articulación temporomandibular'), findsOneWidget);
      expect(find.textContaining('Aplica la regla 20-20-20'), findsOneWidget);

      expect(find.text('2 minutos'), findsNWidgets(3));
      expect(find.text('3 minutos'), findsOneWidget);

      // 5. Botones comenzar y estado pendiente
      expect(find.text('Comenzar'), findsNWidgets(4));
      expect(find.text('Pendiente'), findsNWidgets(4));
    });

    testWidgets('tapping Comenzar on Estiramiento de cuello starts activity and updates state',
        (tester) async {
      configureViewport(tester);
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      final neckStartBtn = find.byKey(const Key('btn_start_neck_stretch'));
      expect(neckStartBtn, findsOneWidget);

      await tester.tap(neckStartBtn);
      await tester.pump();

      final element = tester.element(find.byType(RelaxationScreen));
      final container = ProviderScope.containerOf(element);
      final state = container.read(relaxationControllerProvider);

      expect(state.activeActivity, isNotNull);
      expect(state.activeActivity!.id, equals('neck_stretch'));
      expect(state.isPlaying, isTrue);
    });
  });
}
