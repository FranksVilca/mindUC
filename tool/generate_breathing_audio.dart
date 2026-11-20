// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() {
  const sampleRate = 22050;

  final audioDir = Directory('assets/audio');
  if (!audioDir.existsSync()) {
    audioDir.createSync(recursive: true);
  }

  // 1. Inhale sound (4.5s rising gentle airflow)
  final inhaleSamples = generateInhaleSamples(sampleRate, 4.5);
  final inhaleWav = generateWav(samples: inhaleSamples, sampleRate: sampleRate);
  File('assets/audio/breath_inhale.wav').writeAsBytesSync(inhaleWav);
  print('Generated assets/audio/breath_inhale.wav (${inhaleWav.length} bytes)');

  // 2. Hold sound (4.0s serene Tibetan singing bowl / bell tone at 432Hz)
  final holdSamples = generateHoldSamples(sampleRate, 4.0);
  final holdWav = generateWav(samples: holdSamples, sampleRate: sampleRate);
  File('assets/audio/breath_hold.wav').writeAsBytesSync(holdWav);
  print('Generated assets/audio/breath_hold.wav (${holdWav.length} bytes)');

  // 3. Exhale sound (6.0s smooth warm descending release)
  final exhaleSamples = generateExhaleSamples(sampleRate, 6.0);
  final exhaleWav = generateWav(samples: exhaleSamples, sampleRate: sampleRate);
  File('assets/audio/breath_exhale.wav').writeAsBytesSync(exhaleWav);
  print('Generated assets/audio/breath_exhale.wav (${exhaleWav.length} bytes)');
}

List<double> generateInhaleSamples(int sampleRate, double durationSeconds) {
  final numSamples = (sampleRate * durationSeconds).toInt();
  final random = Random(42);
  final samples = List<double>.filled(numSamples, 0.0);

  double filter1 = 0.0;
  double filter2 = 0.0;

  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final white = random.nextDouble() * 2.0 - 1.0;

    // Gentle 2-pole lowpass/bandpass filter for airflow resonance
    filter1 = 0.85 * filter1 + 0.15 * white;
    filter2 = 0.88 * filter2 + 0.12 * filter1;

    // Amplitude envelope: starts gently and swells smoothly like lungs filling up
    double envelope;
    if (t < 0.3) {
      envelope = t / 0.3;
    } else if (t < 3.8) {
      envelope = 0.2 + 0.8 * sin((t - 0.3) / 3.5 * (pi / 2));
    } else {
      // Gentle fade out at the end of inhale
      envelope = max(0.0, 1.0 - (t - 3.8) / 0.7);
    }

    // Soft formant tone to give body to the breath
    final breathTone = sin(2 * pi * 480.0 * t) * 0.06;

    samples[i] = (filter2 * 0.65 + breathTone) * envelope * 0.55;
  }

  return samples;
}

List<double> generateHoldSamples(int sampleRate, double durationSeconds) {
  final numSamples = (sampleRate * durationSeconds).toInt();
  final samples = List<double>.filled(numSamples, 0.0);

  const fundamental = 432.0;

  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;

    // Gentle singing bowl tone with warm natural harmonics and exponential decay
    final env = exp(-t / 1.8);
    final s1 = sin(2 * pi * fundamental * t) * 0.5;
    final s2 = sin(2 * pi * (fundamental * 2) * t) * 0.15 * exp(-t / 1.2);
    final s3 = sin(2 * pi * (fundamental * 3) * t) * 0.06 * exp(-t / 0.8);
    final vibrato = sin(2 * pi * 4.5 * t) * 0.02;

    samples[i] = (s1 + s2 + s3) * env * (1.0 + vibrato) * 0.38;
  }

  return samples;
}

List<double> generateExhaleSamples(int sampleRate, double durationSeconds) {
  final numSamples = (sampleRate * durationSeconds).toInt();
  final random = Random(88);
  final samples = List<double>.filled(numSamples, 0.0);

  double filter1 = 0.0;
  double filter2 = 0.0;

  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final white = random.nextDouble() * 2.0 - 1.0;

    // Warm lower-frequency filter for relaxing exhale sigh
    filter1 = 0.92 * filter1 + 0.08 * white;
    filter2 = 0.90 * filter2 + 0.10 * filter1;

    // Envelope: initial soft crest, then gentle, relaxing gradual decay
    final attack = (t < 0.4) ? (t / 0.4) : 1.0;
    final decay = exp(-t / 2.6);
    final envelope = attack * decay;

    // Warm undertone
    final warmTone = sin(2 * pi * 320.0 * t) * 0.04 * envelope;

    samples[i] = (filter2 * 0.7 + warmTone) * envelope * 0.6;
  }

  return samples;
}

Uint8List generateWav({required List<double> samples, required int sampleRate}) {
  final numSamples = samples.length;
  final subchunk2Size = numSamples * 2;
  final chunkSize = 36 + subchunk2Size;

  final byteData = ByteData(44 + subchunk2Size);

  // RIFF Chunk
  byteData.setUint8(0, 0x52); // 'R'
  byteData.setUint8(1, 0x49); // 'I'
  byteData.setUint8(2, 0x46); // 'F'
  byteData.setUint8(3, 0x46); // 'F'
  byteData.setUint32(4, chunkSize, Endian.little);
  byteData.setUint8(8, 0x57);  // 'W'
  byteData.setUint8(9, 0x41);  // 'A'
  byteData.setUint8(10, 0x56); // 'V'
  byteData.setUint8(11, 0x45); // 'E'

  // 'fmt ' Subchunk
  byteData.setUint8(12, 0x66); // 'f'
  byteData.setUint8(13, 0x6D); // 'm'
  byteData.setUint8(14, 0x74); // 't'
  byteData.setUint8(15, 0x20); // ' '
  byteData.setUint32(16, 16, Endian.little); // PCM
  byteData.setUint16(20, 1, Endian.little);  // AudioFormat = PCM
  byteData.setUint16(22, 1, Endian.little);  // Mono
  byteData.setUint32(24, sampleRate, Endian.little);
  byteData.setUint32(28, sampleRate * 2, Endian.little);
  byteData.setUint16(32, 2, Endian.little);
  byteData.setUint16(34, 16, Endian.little); // 16-bit

  // 'data' Subchunk
  byteData.setUint8(36, 0x64); // 'd'
  byteData.setUint8(37, 0x61); // 'a'
  byteData.setUint8(38, 0x74); // 't'
  byteData.setUint8(39, 0x61); // 'a'
  byteData.setUint32(40, subchunk2Size, Endian.little);

  int offset = 44;
  for (int i = 0; i < numSamples; i++) {
    final clamped = samples[i].clamp(-1.0, 1.0);
    final pcm16 = (clamped * 32767.0).round();
    byteData.setInt16(offset, pcm16, Endian.little);
    offset += 2;
  }

  return byteData.buffer.asUint8List();
}
