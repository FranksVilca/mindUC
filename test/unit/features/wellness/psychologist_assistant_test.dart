import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/core/router/route_names.dart';
import 'package:minduc/features/wellness/data/datasources/gemini_psychologist_datasource.dart';
import 'package:minduc/features/wellness/data/repositories/psychologist_assistant_repository_impl.dart';
import 'package:minduc/features/wellness/presentation/controllers/psychologist_assistant_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late GeminiPsychologistDataSource dataSource;
  late PsychologistAssistantRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dataSource = GeminiPsychologistDataSource(preferences: prefs);
    repository = PsychologistAssistantRepositoryImpl(datasource: dataSource);
  });

  group('GeminiPsychologistDataSource Offline Tests', () {
    test('askPsychologist returns crisis protocol response for emergency keywords', () async {
      final response = await dataSource.askPsychologist(
        userMessage: 'No quiero vivir, me siento desesperado',
        studentName: 'Carlos',
      );

      expect(response.actionType, 'crisis_support');
      expect(response.actionRoute, AppRoutes.community);
      expect(response.text.contains('Línea de Apoyo Psicológico') || response.text.contains('urgencia'), isTrue);
    });

    test('askPsychologist returns breathing recommendation for anxiety prompt', () async {
      final response = await dataSource.askPsychologist(
        userMessage: 'Tengo mucha ansiedad y pánico por un examen',
        studentName: 'María',
      );

      expect(response.actionType, 'breathing');
      expect(response.actionRoute, AppRoutes.breathingSession);
      expect(response.actionLabel?.toLowerCase(), contains('respiración'));
      expect(response.text.isNotEmpty, isTrue);
    });

    test('askPsychologist returns pomodoro recommendation for focus/procrastination', () async {
      final response = await dataSource.askPsychologist(
        userMessage: 'No logro concentrarme y procrastino todo el día',
        studentName: 'Pedro',
      );

      expect(response.actionType, 'pomodoro');
      expect(response.actionRoute, AppRoutes.pomodoroSession);
      expect(response.actionLabel, contains('Pomodoro'));
    });

    test('askPsychologist returns relaxation recommendation for tiredness/stress', () async {
      final response = await dataSource.askPsychologist(
        userMessage: 'Me siento muy cansado y con tensión muscular en el cuello',
        studentName: 'Lucía',
      );

      expect(response.actionType, 'relaxation');
      expect(response.actionRoute, AppRoutes.relaxation);
    });

    test('askPsychologist returns journal recommendation for sadness or overthinking', () async {
      final response = await dataSource.askPsychologist(
        userMessage: 'Tengo pensamientos negativos constantes y me siento muy triste',
        studentName: 'Ana',
      );

      expect(response.actionType, 'journal');
      expect(response.actionRoute, AppRoutes.journalNew);
    });

    test('getInitialGreeting personalized with user name and mood', () {
      final greeting = dataSource.getInitialGreeting(
        studentName: 'Mateo',
        currentMood: 'Abrumado',
      );

      expect(greeting.text, contains('Mateo'));
      expect(greeting.text, contains('abrumado'));
      expect(greeting.isUser, isFalse);
    });
  });

  group('PsychologistAssistantNotifier Controller Tests', () {
    test('initial state has one greeting message from psychologist', () async {
      final notifier = PsychologistAssistantNotifier(
        repository: repository,
        studentName: 'Estudiante',
        currentMood: 'Tranquilo',
      );

      // Allow async _initialize to complete
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(notifier.state.messages.length, 1);
      expect(notifier.state.messages.first.isUser, isFalse);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('sendMessage adds user message and awaits psychologist reply', () async {
      final notifier = PsychologistAssistantNotifier(
        repository: repository,
        studentName: 'Estudiante',
        currentMood: 'Tranquilo',
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await notifier.sendMessage('Siento bastante estrés con mis entregas');

      expect(notifier.state.messages.length, 3); // 1 initial + 1 user + 1 assistant
      expect(notifier.state.messages[1].isUser, isTrue);
      expect(notifier.state.messages[1].text, 'Siento bastante estrés con mis entregas');
      expect(notifier.state.messages[2].isUser, isFalse);
      expect(notifier.state.isLoading, isFalse);
    });

    test('resetConversation clears history back to fresh initial greeting', () async {
      final notifier = PsychologistAssistantNotifier(
        repository: repository,
        studentName: 'Estudiante',
        currentMood: 'Tranquilo',
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await notifier.sendMessage('Hola');
      expect(notifier.state.messages.length, 3);

      notifier.resetConversation();
      expect(notifier.state.messages.length, 1);
      expect(notifier.state.messages.first.isUser, isFalse);
    });
  });
}
