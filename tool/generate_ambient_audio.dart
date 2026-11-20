// ignore_for_file: avoid_print, prefer_const_declarations

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

void main() {
  const sampleRate = 22050;
  const durationSeconds = 6; // 6-second seamless loop
  final numSamples = sampleRate * durationSeconds;

  final audioDir = Directory('assets/audio');
  if (!audioDir.existsSync()) {
    audioDir.createSync(recursive: true);
  }

  // 1. Generate Rain
  final rainBytes = generateWav(
    samples: generateRainSamples(numSamples, sampleRate),
    sampleRate: sampleRate,
  );
  File('assets/audio/rain.wav').writeAsBytesSync(rainBytes);
  print('Generated assets/audio/rain.wav (${rainBytes.length} bytes)');

  // 2. Generate Cafe
  final cafeBytes = generateWav(
    samples: generateCafeSamples(numSamples, sampleRate),
    sampleRate: sampleRate,
  );
  File('assets/audio/cafe.wav').writeAsBytesSync(cafeBytes);
  print('Generated assets/audio/cafe.wav (${cafeBytes.length} bytes)');

  // 3. Generate Forest
  final forestBytes = generateWav(
    samples: generateForestSamples(numSamples, sampleRate),
    sampleRate: sampleRate,
  );
  File('assets/audio/forest.wav').writeAsBytesSync(forestBytes);
  print('Generated assets/audio/forest.wav (${forestBytes.length} bytes)');
}

List<double> generateRainSamples(int numSamples, int sampleRate) {
  final random = Random(42);
  final samples = List<double>.filled(numSamples, 0.0);

  double lowpass = 0.0;
  double pink = 0.0;

  for (int i = 0; i < numSamples; i++) {
    final white = (random.nextDouble() * 2.0 - 1.0);
    // 2-pole gentle filter for rainfall hiss & wash
    pink = 0.88 * pink + 0.12 * white;
    lowpass = 0.75 * lowpass + 0.25 * pink;

    samples[i] = lowpass * 0.45;
  }

  // Add raindrop splatters
  int i = 0;
  while (i < numSamples - 1000) {
    i += 400 + random.nextInt(1200);
    if (i >= numSamples - 1000) break;
    final dropFreq = 900.0 + random.nextDouble() * 1400.0;
    final dropLen = 150 + random.nextInt(250);
    final amp = 0.15 + random.nextDouble() * 0.25;

    for (int j = 0; j < dropLen && (i + j) < numSamples; j++) {
      final t = j / sampleRate;
      final env = exp(-j / 40.0);
      samples[i + j] += amp * sin(2 * pi * dropFreq * t) * env;
    }
  }

  applyLoopCrossfade(samples, sampleRate, fadeSeconds: 0.4);
  return samples;
}

List<double> generateCafeSamples(int numSamples, int sampleRate) {
  final random = Random(1337);
  final samples = List<double>.filled(numSamples, 0.0);

  double filter1 = 0.0;
  double filter2 = 0.0;

  for (int i = 0; i < numSamples; i++) {
    final white = (random.nextDouble() * 2.0 - 1.0);
    filter1 = 0.94 * filter1 + 0.06 * white;
    filter2 = 0.92 * filter2 + 0.08 * filter1;

    // Slow ambient swell
    final lfo = 0.75 + 0.25 * sin(2 * pi * 0.25 * (i / sampleRate));
    samples[i] = filter2 * 0.55 * lfo;
  }

  // Occasional gentle cup or porcelain clink at a distance
  int i = sampleRate ~/ 2;
  while (i < numSamples - 2000) {
    i += sampleRate + random.nextInt(sampleRate * 2);
    if (i >= numSamples - 2000) break;
    final clinkFreq = 2200.0 + random.nextDouble() * 800.0;
    final clinkLen = 400;
    final amp = 0.08 + random.nextDouble() * 0.08;

    for (int j = 0; j < clinkLen && (i + j) < numSamples; j++) {
      final t = j / sampleRate;
      final env = exp(-j / 50.0);
      samples[i + j] += amp * sin(2 * pi * clinkFreq * t) * env;
    }
  }

  applyLoopCrossfade(samples, sampleRate, fadeSeconds: 0.4);
  return samples;
}

List<double> generateForestSamples(int numSamples, int sampleRate) {
  final random = Random(999);
  final samples = List<double>.filled(numSamples, 0.0);

  double breeze = 0.0;
  for (int i = 0; i < numSamples; i++) {
    final white = (random.nextDouble() * 2.0 - 1.0);
    breeze = 0.96 * breeze + 0.04 * white;

    // Slow breeze wave (0.18 Hz)
    final swell = 0.6 + 0.4 * sin(2 * pi * 0.18 * (i / sampleRate));
    samples[i] = breeze * 0.4 * swell;
  }

  // Soft distant melodic bird trill
  for (int phrase = 0; phrase < 2; phrase++) {
    final startIdx = (sampleRate * (1.2 + phrase * 2.8)).toInt();
    if (startIdx + 4000 < numSamples) {
      final baseFreq = 2400.0 + phrase * 300.0;
      for (int k = 0; k < 3; k++) {
        final noteStart = startIdx + k * 800;
        for (int j = 0; j < 500 && (noteStart + j) < numSamples; j++) {
          final t = j / sampleRate;
          final env = sin(pi * (j / 500));
          final freq = baseFreq + (k * 220.0) + sin(2 * pi * 25.0 * t) * 60.0;
          samples[noteStart + j] += 0.06 * sin(2 * pi * freq * t) * env;
        }
      }
    }
  }

  applyLoopCrossfade(samples, sampleRate, fadeSeconds: 0.4);
  return samples;
}

void applyLoopCrossfade(List<double> samples, int sampleRate, {required double fadeSeconds}) {
  final fadeLen = (fadeSeconds * sampleRate).toInt();
  final total = samples.length;

  for (int i = 0; i < fadeLen; i++) {
    final alpha = i / fadeLen;
    final endIdx = total - fadeLen + i;
    // Crossfade beginning and end so loop is perfectly seamless
    final blended = samples[i] * alpha + samples[endIdx] * (1.0 - alpha);
    samples[i] = blended;
    samples[endIdx] = blended;
  }
}

Uint8List generateWav({required List<double> samples, required int sampleRate}) {
  final numSamples = samples.length;
  final subchunk2Size = numSamples * 2; // 16-bit mono = 2 bytes per sample
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
  byteData.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
  byteData.setUint16(20, 1, Endian.little);  // AudioFormat (1 for PCM)
  byteData.setUint16(22, 1, Endian.little);  // NumChannels (1 = Mono)
  byteData.setUint32(24, sampleRate, Endian.little); // SampleRate
  byteData.setUint32(28, sampleRate * 2, Endian.little); // ByteRate (SampleRate * 1 * 16/8)
  byteData.setUint16(32, 2, Endian.little);  // BlockAlign (1 * 16/8)
  byteData.setUint16(34, 16, Endian.little); // BitsPerSample (16)

  // 'data' Subchunk
  byteData.setUint8(36, 0x64); // 'd'
  byteData.setUint8(37, 0x61); // 'a'
  byteData.setUint8(38, 0x74); // 't'
  byteData.setUint8(39, 0x61); // 'a'
  byteData.setUint32(40, subchunk2Size, Endian.little);

  // PCM Samples
  int offset = 44;
  for (int i = 0; i < numSamples; i++) {
    final clamped = samples[i].clamp(-1.0, 1.0);
    final pcm16 = (clamped * 32767.0).round();
    byteData.setInt16(offset, pcm16, Endian.little);
    offset += 2;
  }

  return byteData.buffer.asUint8List();
}
