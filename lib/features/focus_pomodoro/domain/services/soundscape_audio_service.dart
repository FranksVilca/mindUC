import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Servicio de audio ambiental para la sesión Pomodoro de mindUC.
/// Gestiona la reproducción en bucle continuo, control de volumen y compatibilidad
/// multiplataforma (Web, Android, iOS y Desktop).
class SoundscapeAudioService {
  SoundscapeAudioService({AudioPlayer? player}) : _injectedPlayer = player;

  AudioPlayer? _injectedPlayer;
  AudioPlayer get _player => _injectedPlayer ??= AudioPlayer();

  StreamSubscription<PlayerState>? _playerStateSubscription;
  bool _isInitialized = false;
  String? _currentTrackId;
  bool _isPlaying = false;
  double _volume = 0.7;
  bool _autoplayBlocked = false;

  String? get currentTrackId => _currentTrackId;
  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  bool get isAutoplayBlocked => _autoplayBlocked;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      _playerStateSubscription = _player.onPlayerStateChanged.listen((state) {
        _isPlaying = (state == PlayerState.playing);
      });
      _isInitialized = true;
    } catch (e) {
      debugPrint('SoundscapeAudioService init notice: $e');
    }
  }

  /// Reproduce la pista ambiental seleccionada en bucle con el volumen indicado.
  Future<bool> playTrack(String trackId, {double? volume}) async {
    await _ensureInitialized();
    final effectiveVolume = (volume ?? _volume).clamp(0.0, 1.0);
    _volume = effectiveVolume;
    _currentTrackId = trackId;

    try {
      // Detener cualquier reproducción previa para evitar superposición
      if (_isPlaying) {
        await _player.stop();
      }
      await _player.setVolume(effectiveVolume);
      final assetPath = 'audio/$trackId.wav';
      await _player.play(AssetSource(assetPath));
      _isPlaying = true;
      _autoplayBlocked = false;
      return true;
    } catch (e) {
      debugPrint('Error playing soundscape ($trackId): $e');
      // En Web, si el navegador bloquea la reproducción automática por falta de gesto previo
      if (e.toString().contains('NotAllowedError') ||
          e.toString().contains('user gesture') ||
          e.toString().contains('interact')) {
        _autoplayBlocked = true;
      }
      _isPlaying = false;
      return false;
    }
  }

  /// Pausa la reproducción del ambiente sonoro manteniendo la posición.
  Future<void> pause() async {
    try {
      if (_injectedPlayer != null) {
        await _player.pause();
      }
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error pausing soundscape: $e');
    }
  }

  /// Reanuda la reproducción si hay una pista seleccionada.
  Future<void> resume() async {
    if (_currentTrackId == null) return;
    try {
      await _player.resume();
      _isPlaying = true;
      _autoplayBlocked = false;
    } catch (e) {
      debugPrint('Error resuming soundscape: $e');
      if (_currentTrackId != null) {
        await playTrack(_currentTrackId!, volume: _volume);
      }
    }
  }

  /// Detiene por completo la reproducción del ambiente sonoro y reinicia la pista.
  Future<void> stop() async {
    try {
      if (_injectedPlayer != null) {
        await _player.stop();
      }
      _isPlaying = false;
      _autoplayBlocked = false;
    } catch (e) {
      debugPrint('Error stopping soundscape: $e');
    }
  }

  /// Ajusta suavemente el nivel de volumen entre 0.0 (silencio) y 1.0 (máximo).
  Future<void> setVolume(double newVolume) async {
    _volume = newVolume.clamp(0.0, 1.0);
    try {
      if (_injectedPlayer != null) {
        await _player.setVolume(_volume);
      }
    } catch (e) {
      debugPrint('Error setting soundscape volume: $e');
    }
  }

  void dispose() {
    try {
      _playerStateSubscription?.cancel();
      _playerStateSubscription = null;
      _injectedPlayer?.dispose();
    } catch (_) {}
  }
}
