import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/auth/domain/entities/app_avatar.dart';

void main() {
  group('AppAvatar Entity Unit Tests', () {
    test('contains exactly the 3 required animal avatars', () {
      expect(AppAvatar.all.length, 3);
      final ids = AppAvatar.all.map((a) => a.id).toList();
      expect(ids, containsAll(['panda', 'koala', 'tiger']));
    });

    test('verifies animal avatars identity, emoji, and display names', () {
      expect(AppAvatar.panda.emoji, '🐼');
      expect(AppAvatar.panda.name, 'Oso panda');

      expect(AppAvatar.koala.emoji, '🐨');
      expect(AppAvatar.koala.name, 'Koala');

      expect(AppAvatar.tiger.emoji, '🐯');
      expect(AppAvatar.tiger.name, 'Tigre');
    });

    test('defaults to panda when id is null, empty or unrecognized', () {
      expect(AppAvatar.fromId(null), AppAvatar.panda);
      expect(AppAvatar.fromId(''), AppAvatar.panda);
      expect(AppAvatar.fromId('   '), AppAvatar.panda);
      expect(AppAvatar.fromId('unknown_creature'), AppAvatar.panda);
    });

    test('resolves case-insensitively and Spanish variants', () {
      expect(AppAvatar.fromId('PANDA'), AppAvatar.panda);
      expect(AppAvatar.fromId('oso panda'), AppAvatar.panda);
      expect(AppAvatar.fromId('KOALA'), AppAvatar.koala);
      expect(AppAvatar.fromId('tiger'), AppAvatar.tiger);
      expect(AppAvatar.fromId('tigre'), AppAvatar.tiger);
      expect(AppAvatar.fromId('crocodile'), AppAvatar.tiger);
      expect(AppAvatar.fromId('cocodrilo'), AppAvatar.tiger);
    });

    test('resolves directly from emoji characters', () {
      expect(AppAvatar.fromId('🐼'), AppAvatar.panda);
      expect(AppAvatar.fromId('🐨'), AppAvatar.koala);
      expect(AppAvatar.fromId('🐯'), AppAvatar.tiger);
      expect(AppAvatar.fromId('🐊'), AppAvatar.tiger);
    });
  });
}
