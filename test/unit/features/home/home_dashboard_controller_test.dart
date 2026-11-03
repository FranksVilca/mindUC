import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/data/datasources/fake_auth_datasource.dart';
import 'package:minduc/features/auth/data/models/user_model.dart';
import 'package:minduc/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:minduc/features/home/data/datasources/fake_mood_datasource.dart';
import 'package:minduc/features/home/data/repositories/mood_repository_impl.dart';
import 'package:minduc/features/home/domain/entities/mood_type.dart';
import 'package:minduc/features/home/domain/usecases/record_mood_usecase.dart';
import 'package:minduc/features/home/presentation/controllers/home_dashboard_controller.dart';

void main() {
  late FakeAuthDataSource fakeAuthDataSource;
  late AuthRepositoryImpl authRepo;
  late FakeMoodDataSource fakeMoodDataSource;
  late MoodRepositoryImpl moodRepo;
  late GetTodayMoodUseCase getTodayMoodUseCase;
  late RecordMoodUseCase recordMoodUseCase;

  setUp(() {
    fakeAuthDataSource = FakeAuthDataSource(
      const UserModel(
        uid: 'camila_123',
        email: 'camila.soto@uc.cl',
        displayName: 'Camila Soto',
        department: 'Psicología',
        emailVerified: true,
        createdAtMillis: 1792873200000,
      ),
    );
    authRepo = AuthRepositoryImpl(fakeDataSource: fakeAuthDataSource);
    fakeMoodDataSource = FakeMoodDataSource();
    moodRepo = MoodRepositoryImpl(fakeDataSource: fakeMoodDataSource);
    getTodayMoodUseCase = GetTodayMoodUseCase(moodRepo);
    recordMoodUseCase = RecordMoodUseCase(moodRepo);
  });

  group('HomeDashboardNotifier Unit Tests', () {
    test('resolves user first name and default quick access items', () {
      final notifier = HomeDashboardNotifier(
        authRepo: authRepo,
        getTodayMoodUseCase: getTodayMoodUseCase,
        recordMoodUseCase: recordMoodUseCase,
      );

      expect(notifier.state.summary.greetingName, equals('Camila'));
      expect(notifier.state.quickAccessItems.length, equals(4));
    });

    test('selectMood updates selectedMood in state and saves in repository', () async {
      final notifier = HomeDashboardNotifier(
        authRepo: authRepo,
        getTodayMoodUseCase: getTodayMoodUseCase,
        recordMoodUseCase: recordMoodUseCase,
      );

      final success = await notifier.selectMood(MoodType.feliz);

      expect(success, isTrue);
      expect(notifier.state.selectedMood, equals(MoodType.feliz));
      expect(notifier.state.summary.todayMood, equals(MoodType.feliz));
    });
  });
}
