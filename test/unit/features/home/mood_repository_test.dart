import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/home/data/datasources/fake_mood_datasource.dart';
import 'package:minduc/features/home/data/repositories/mood_repository_impl.dart';
import 'package:minduc/features/home/domain/entities/mood_type.dart';

void main() {
  late FakeMoodDataSource fakeDataSource;
  late MoodRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeMoodDataSource();
    repository = MoodRepositoryImpl(fakeDataSource: fakeDataSource);
  });

  group('MoodRepositoryImpl Unit Tests', () {
    test('saveMood returns saved MoodEntry with correct fields', () async {
      final result = await repository.saveMood(
        userId: 'camila_123',
        dateString: '2026-10-24',
        mood: MoodType.calma,
      );

      expect(result.isSuccess, isTrue);
      final entry = result.dataOrNull!;
      expect(entry.userId, equals('camila_123'));
      expect(entry.dateString, equals('2026-10-24'));
      expect(entry.mood, equals(MoodType.calma));
    });

    test('getTodayMood returns null when no entry exists for today', () async {
      final result = await repository.getTodayMood(
        userId: 'camila_123',
        dateString: '2026-10-24',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isNull);
    });

    test('getTodayMood returns saved entry', () async {
      await repository.saveMood(
        userId: 'camila_123',
        dateString: '2026-10-24',
        mood: MoodType.feliz,
      );

      final result = await repository.getTodayMood(
        userId: 'camila_123',
        dateString: '2026-10-24',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.mood, equals(MoodType.feliz));
    });

    test('saveMood overwrites mood on same date (single entry per day)', () async {
      await repository.saveMood(
        userId: 'camila_123',
        dateString: '2026-10-24',
        mood: MoodType.calma,
      );

      await repository.saveMood(
        userId: 'camila_123',
        dateString: '2026-10-24',
        mood: MoodType.energica,
      );

      final result = await repository.getTodayMood(
        userId: 'camila_123',
        dateString: '2026-10-24',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.mood, equals(MoodType.energica));
    });
  });
}
