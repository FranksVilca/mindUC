import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../entities/breathing_phase.dart';

/// Contrato del servicio de guía auditiva biomecánica de respiración consciente.
abstract class BreathingAudioService {
  bool get isSoundEnabled;
  double get volume;

  void setSoundEnabled(bool enabled);
  void toggleSound();
  void setVolume(double vol);
  Future<void> playPhase(BreathingPhase phase);
  Future<void> stop();
  void dispose();

  factory BreathingAudioService({
    AudioPlayer? player,
    bool initialSoundEnabled,
  }) = BreathingAudioServiceImpl;
}

/// Implementación de producción con Audioplayers y archivos locales serenos.
class BreathingAudioServiceImpl implements BreathingAudioService {
  AudioPlayer? _playerInstance;
  bool _isSoundEnabled;
  double _volume;

  BreathingAudioServiceImpl({
    AudioPlayer? player,
    bool initialSoundEnabled = true,
    double volume = 0.7,
  })  : _playerInstance = player,
        _isSoundEnabled = initialSoundEnabled,
        _volume = volume;

  @override
  bool get isSoundEnabled => _isSoundEnabled;

  @override
  double get volume => _volume;

  AudioPlayer? _getOrCreatePlayer() {
    if (_playerInstance != null) return _playerInstance;
    try {
      _playerInstance = AudioPlayer();
      return _playerInstance;
    } catch (e) {
      debugPrint('[BreathingAudioService] Error al inicializar AudioPlayer: $e');
      return null;
    }
  }

  @override
  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
    if (!enabled) {
      stop();
    }
  }

  @override
  void toggleSound() {
    setSoundEnabled(!_isSoundEnabled);
  }

  @override
  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    try {
      _playerInstance?.setVolume(_volume);
    } catch (_) {}
  }

  @override
  Future<void> playPhase(BreathingPhase phase) async {
    if (!_isSoundEnabled) return;

    try {
      final player = _getOrCreatePlayer();
      if (player == null) return;

      await player.stop();
      await player.setVolume(_volume);

      switch (phase) {
        case BreathingPhase.inhale:
          await player.play(AssetSource('audio/breath_inhale.wav'));
          break;
        case BreathingPhase.hold:
          await player.play(AssetSource('audio/breath_hold.wav'));
          break;
        case BreathingPhase.exhale:
          await player.play(AssetSource('audio/breath_exhale.wav'));
          break;
        case BreathingPhase.rest:
          // Pausa en silencio
          break;
      }
    } catch (e) {
      debugPrint('[BreathingAudioService] Error al reproducir audio guía ($phase): $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      if (_playerInstance != null) {
        await _playerInstance!.stop();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    try {
      _playerInstance?.dispose();
      _playerInstance = null;
    } catch (_) {}
  }
}

/// Implementación simulada (Fake) para pruebas unitarias y de widgets
/// sin dependencias del motor de audio de la plataforma.
class FakeBreathingAudioService implements BreathingAudioService {
  @override
  bool isSoundEnabled;

  @override
  double volume;

  final List<BreathingPhase> playedPhases = [];
  bool isStopped = false;

  FakeBreathingAudioService({
    this.isSoundEnabled = true,
    this.volume = 0.7,
  });

  @override
  void setSoundEnabled(bool enabled) {
    isSoundEnabled = enabled;
  }

  @override
  void toggleSound() {
    isSoundEnabled = !isSoundEnabled;
  }

  @override
  void setVolume(double vol) {
    volume = vol;
  }

  @override
  Future<void> playPhase(BreathingPhase phase) async {
    if (isSoundEnabled) {
      playedPhases.add(phase);
    }
  }

  @override
  Future<void> stop() async {
    isStopped = true;
  }

  @override
  void dispose() {}
}
