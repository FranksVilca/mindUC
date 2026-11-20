/// Entidad que representa una pista de sonido ambiental relajante para la sesión.
class SoundscapeTrack {
  const SoundscapeTrack({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    this.audioAsset,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconName;
  final String? audioAsset;

  /// Ruta al archivo de audio empaquetado en assets/audio/.
  String get effectiveAudioAsset => audioAsset ?? 'audio/$id.wav';

  /// Catálogo predeterminado de ambientes sonoros de mindUC.
  static const List<SoundscapeTrack> defaultTracks = [
    SoundscapeTrack(
      id: 'rain',
      title: 'Lluvia campus',
      subtitle: 'En reproducción',
      iconName: 'cloud',
      audioAsset: 'audio/rain.wav',
    ),
    SoundscapeTrack(
      id: 'cafe',
      title: 'Cafetería calma',
      subtitle: 'Murmullo suave',
      iconName: 'coffee',
      audioAsset: 'audio/cafe.wav',
    ),
    SoundscapeTrack(
      id: 'forest',
      title: 'Bosque natural',
      subtitle: 'Natural',
      iconName: 'forest',
      audioAsset: 'audio/forest.wav',
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundscapeTrack &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          subtitle == other.subtitle &&
          iconName == other.iconName;

  @override
  int get hashCode => Object.hash(id, title, subtitle, iconName);
}
