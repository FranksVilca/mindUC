import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/services/voice/speech_recognition_service.dart';
import 'package:minduc/features/agenda/data/datasources/local_agenda_datasource.dart';
import 'package:minduc/features/agenda/data/repositories/local_agenda_repository_impl.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_activity.dart';
import 'package:minduc/features/agenda/domain/entities/agenda_category.dart';
import 'package:minduc/features/agenda/presentation/controllers/agenda_controller.dart';
import 'package:minduc/features/agenda/presentation/screens/agenda_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementación simulada del servicio de reconocimiento de voz para pruebas unitarias y de widgets
class FakeSpeechRecognitionService implements SpeechRecognitionService {
  bool _isListening = false;
  String simulatedSpeech = 'Estudiar cálculo mañana a las 15:00';

  @override
  bool get isListening => _isListening;

  @override
  bool get isAvailable => true;

  @override
  Future<bool> initialize() async => true;

  @override
  Future<bool> requestMicrophonePermission() async => true;

  @override
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    required void Function(String error) onError,
  }) async {
    _isListening = true;
    onResult(simulatedSpeech, true);
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
  }

  @override
  void dispose() {
    _isListening = false;
  }
}

void main() {
  late FakeSpeechRecognitionService fakeSpeech;
  late LocalAgendaDataSource dataSource;
  late LocalAgendaRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    LocalAgendaDataSource.clearActivities();
    fakeSpeech = FakeSpeechRecognitionService();
    dataSource = LocalAgendaDataSource(
      initialActivities: [
        AgendaActivity(
          id: 'test-act-1',
          title: 'Lectura de Psicología',
          subtitle: 'Capítulo 3',
          scheduledDateTime: DateTime(2024, 10, 24, 10, 0),
          category: AgendaCategory.estudioTrabajo,
          isCompleted: false,
          createdAt: DateTime(2024, 10, 24, 8, 0),
        ),
      ],
    );
    repository = LocalAgendaRepositoryImpl(dataSource: dataSource);
  });

  tearDown(() {
    LocalAgendaDataSource.clearActivities();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        agendaRepositoryProvider.overrideWithValue(repository),
        speechRecognitionServiceProvider.overrideWithValue(fakeSpeech),
        agendaControllerProvider.overrideWith(
          (ref) => AgendaNotifier(
            repository: repository,
            initialDate: DateTime(2024, 10, 24),
          ),
        ),
      ],
      child: const MaterialApp(
        home: AgendaScreen(),
      ),
    );
  }

  group('Agenda Date & Voice Assistant Widget Tests', () {
    testWidgets('Muestra campos de Fecha y Hora al crear una nueva actividad',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Pulsar botón '+ Nueva'
      await tester.tap(find.text('Nueva'));
      await tester.pumpAndSettle();

      // Verificar título del modal de creación
      expect(find.text('Nueva actividad consciente'), findsOneWidget);

      // Verificar que ambos campos existen en la UI
      expect(find.text('Fecha programada'), findsOneWidget);
      expect(find.text('Horario programado'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
      expect(find.byIcon(Icons.access_time_rounded), findsOneWidget);

      // Ingresar título y descripción
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Taller de respiración consciente');
      await tester.enterText(textFields.last, 'En el patio central');

      // Guardar actividad
      await tester.tap(find.text('Guardar actividad'));
      await tester.pumpAndSettle();

      // Modal cerrado y actividad creada
      expect(find.text('Nueva actividad consciente'), findsNothing);
      expect(find.text('Taller de respiración consciente'), findsOneWidget);
    });

    testWidgets('Permite editar una actividad existente modificando Fecha y Hora',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Lectura de Psicología'), findsOneWidget);

      // Pulsar en la tarjeta para editar
      await tester.tap(find.text('Lectura de Psicología'));
      await tester.pumpAndSettle();

      // Verificar que el modal abre en modo edición
      expect(find.text('Editar actividad consciente'), findsOneWidget);
      expect(find.text('Actualizar actividad'), findsOneWidget);
      expect(find.text('Fecha programada'), findsOneWidget);
      expect(find.text('Horario programado'), findsOneWidget);

      // Modificar el título
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Lectura de Psicología Avanzada');

      // Guardar cambios
      await tester.tap(find.text('Actualizar actividad'));
      await tester.pumpAndSettle();

      // Verificar actualización
      expect(find.text('Editar actividad consciente'), findsNothing);
      expect(find.text('Lectura de Psicología Avanzada'), findsOneWidget);
    });

    testWidgets(
        'Activa el micrófono, transcribe comando de voz y autocompleta la agenda',
        (tester) async {
      fakeSpeech.simulatedSpeech = 'Estudiar cálculo mañana a las 15:00';

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Pulsar el botón flotante de micrófono
      await tester.tap(find.byIcon(Icons.mic_none_rounded));
      await tester.pumpAndSettle();

      // Verificar que abre el modal del asistente de voz
      expect(find.text('Comando de voz inteligente'), findsOneWidget);
      expect(find.text('"Estudiar cálculo mañana a las 15:00"'), findsOneWidget);

      // Confirmar y completar agenda
      await tester.tap(find.text('Completar agenda'));
      await tester.pumpAndSettle();

      // Verifica que abre el modal de creación con los campos autocompletados
      expect(find.text('Nueva actividad consciente'), findsOneWidget);
      expect(find.text('Estudiar cálculo'), findsOneWidget);
      expect(find.text('Horario programado'), findsOneWidget);
      expect(find.text('15:00 PM'), findsOneWidget);

      // Guardar la actividad generada por voz
      await tester.tap(find.text('Guardar actividad'));
      await tester.pumpAndSettle();

      expect(find.text('Nueva actividad consciente'), findsNothing);
    });
  });
}
