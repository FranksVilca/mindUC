import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/breathing/data/datasources/fake_breathing_datasource.dart';
import 'package:minduc/features/breathing/data/repositories/breathing_repository_impl.dart';
import 'package:minduc/features/breathing/domain/entities/breathing_session_log.dart';

void main() {
  late FakeBreathingDataSource fakeDataSource;
  late BreathingRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeBreathingDataSource();
    repository = BreathingRepositoryImpl(fakeDataSource: fakeDataSource);
  });

  group('BreathingRepositoryImpl Unit Tests', () {
    test('saveSession persists log and retrieves via getUserSessions', () async {
      const log = BreathingSessionLog(
        id: 'session_1',
        userId: 'camila_123',
        techniqueId: 'box_444',
        durationSeconds: 600,
        cyclesCompleted: 12,
        dateString: '2026-10-24',
        timestampMillis: 1792873200000,
      );

      final saveResult = await repository.saveSession(log);
      expect(saveResult.isSuccess, isTrue);

      final fetchResult = await repository.getUserSessions('camila_123');
      expect(fetchResult.isSuccess, isTrue);
      expect(fetchResult.dataOrNull?.length, equals(1));
      expect(fetchResult.dataOrNull?.first.id, equals('session_1'));
    });
  });
}
