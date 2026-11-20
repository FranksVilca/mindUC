import 'package:flutter_test/flutter_test.dart';
import 'package:minduc/features/community_forum/domain/services/community_content_moderator.dart';

void main() {
  group('CommunityContentModerator Domain Service Tests', () {
    test('allows legitimate student reflections and well-being messages', () {
      const legitimateMessages = [
        'Hoy tuve una entrega muy pesada pero hacer una pausa me ayudó mucho 🌿',
        'Necesito consejos para organizar mi tiempo antes de los exámenes.',
        'La sesión de respiración 4-7-8 me devolvió la calma.',
        'Estaba pensando en estudiar en la biblioteca hoy por la tarde.',
      ];

      for (final msg in legitimateMessages) {
        final result = CommunityContentModerator.validate(msg);
        expect(result.isValid, isTrue, reason: 'Failed for message: "$msg"');
        expect(result.message, isNull);
        expect(result.blockedWord, isNull);
      }
    });

    test('avoids false positives on harmless words containing substrings of profanities', () {
      const harmlessWordsWithSubstrings = [
        'Mi computadora se quedó sin batería en plena clase.',
        'Tuvimos una disputa académica muy interesante en el debate.',
        'La reputación de esa facultad es muy alta.',
        'Debo enviar el documento antes de la medianoche.',
      ];

      for (final msg in harmlessWordsWithSubstrings) {
        final result = CommunityContentModerator.validate(msg);
        expect(result.isValid, isTrue,
            reason: 'False positive triggered on legitimate word: "$msg"');
      }
    });

    test('rejects empty or whitespace-only messages', () {
      final emptyResult = CommunityContentModerator.validate('');
      expect(emptyResult.isValid, isFalse);
      expect(emptyResult.reason, ModerationViolationReason.empty);

      final whitespaceResult = CommunityContentModerator.validate('    \n\t   ');
      expect(whitespaceResult.isValid, isFalse);
      expect(whitespaceResult.reason, ModerationViolationReason.empty);
    });

    test('rejects emails and personal contact information (Principio V)', () {
      const privacyViolations = [
        'Escríbeme a mi correo personal: juan.perez@gmail.com',
        'Contáctame por estudiante@uc.cl para coordinar el grupo',
        'Cualquier duda a fvilcaqui@unsa.edu.pe por favor',
      ];

      for (final msg in privacyViolations) {
        final result = CommunityContentModerator.validate(msg);
        expect(result.isValid, isFalse);
        expect(result.reason, ModerationViolationReason.personalData);
        expect(result.message, contains('privacidad'));
      }
    });

    test('detects and blocks direct profanities and insults', () {
      const directInsults = [
        'Esto es una mierda total',
        'Eres un idiota por no estudiar',
        'Qué tipo más imbécil',
        'No seas pendejo y haz tu parte',
        'Ese profe es un conchetumadre',
        'Vete a la chucha',
        'Cállate ctm',
        'Ese weon no hizo nada en el grupo',
        'Estás bien culiao',
      ];

      for (final msg in directInsults) {
        final result = CommunityContentModerator.validate(msg);
        expect(result.isValid, isFalse, reason: 'Did not catch insult in: "$msg"');
        expect(result.reason, ModerationViolationReason.profanity);
        expect(result.blockedWord, isNotNull);
      }
    });

    test('detects and blocks severe harm and intimidation expressions', () {
      const harmMessages = [
        'Ojalá te mueras',
        'Mejor mátate',
        'Deberías suicidarte',
      ];

      for (final msg in harmMessages) {
        final result = CommunityContentModerator.validate(msg);
        expect(result.isValid, isFalse, reason: 'Failed for message: "$msg"');
        expect(result.reason, ModerationViolationReason.profanity);
      }
    });

    test('handles case insensitivity, accents and elongation evasion', () {
      const evasionAttempts = [
        'Qué MIERDA de entrega',
        'Es un IMBÉCIL completo',
        'Puuuuta que estrés',
        'p.u.t.a que difícil',
        'm-i-e-r-d-a de examen',
        'hijo de puta',
        'concha de tu madre',
      ];

      for (final msg in evasionAttempts) {
        final result = CommunityContentModerator.validate(msg);
        expect(result.isValid, isFalse,
            reason: 'Failed to detect evasion technique in: "$msg"');
        expect(result.reason, ModerationViolationReason.profanity);
      }
    });

    test('maskBannedWords replaces prohibited terms with asterisks', () {
      const input = 'Qué mierda de situación con este idiota';
      final masked = CommunityContentModerator.maskBannedWords(input);

      expect(masked.contains('mierda'), isFalse);
      expect(masked.contains('idiota'), isFalse);
      expect(masked.contains('******'), isTrue);
    });
  });
}
