import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/home/data/datasources/fake_mood_datasource.dart';
import 'package:minduc/features/home/data/repositories/mood_repository_impl.dart';
import 'package:minduc/features/home/domain/entities/mood_type.dart';
import 'package:minduc/features/home/domain/usecases/record_mood_usecase.dart';

void main() {
  late FakeMoodDataSource fakeDataSource;
  late MoodRepositoryImpl repository;
  late GetTodayMoodUseCase getTodayMoodUseCase;
  late RecordMoodUseCase recordMoodUseCase;

  setUp(() {
    fakeDataSource = FakeMoodDataSource();
    repository = MoodRepositoryImpl(fakeDataSource: fakeDataSource);
    getTodayMoodUseCase = GetTodayMoodUseCase(repository);
    recordMoodUseCase = RecordMoodUseCase(repository);
  });

  group('Mood UseCases Unit Tests', () {
    test('RecordMoodUseCase successfully saves mood and GetTodayMoodUseCase retrieves it', () async {
      final saveResult = await recordMoodUseCase(
        userId: 'camila_123',
        dateString: '2026-10-24',
        mood: MoodType.calma,
      );

      expect(saveResult.isSuccess, isTrue);
      expect(saveResult.dataOrNull?.mood, equals(MoodType.calma));

      final getResult = await getTodayMoodUseCase(
        userId: 'camila_123',
        dateString: '2026-10-24',
      );

      expect(getResult.isSuccess, isTrue);
      expect(getResult.dataOrNull?.mood, equals(MoodType.calma));
    });
  });
}

