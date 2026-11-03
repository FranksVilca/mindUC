# Data Model: 004-breathing-relaxation (Respiración y Relajación Consciente)

**Feature**: 004-breathing-relaxation  
**Date**: 2026-11-02  
**Status**: Complete  

---

## 1. Domain Entities & Enums

### 1.1 `BreathingPhase` (Enum)
Representa la etapa actual dentro del ciclo biomecánico de respiración:

| Valor | Texto de Instrucción | Guía Biomecánica | Efecto Visual en Círculo |
| :--- | :--- | :--- | :--- |
| `inhale` | Inhala suave | EXPANDE EL ABDOMEN | Expansión suave de escala (1.0 a 1.22) |
| `hold` | Retén el aire | MANTÉN LA CALMA | Escala estable en 1.22 con arco continuo |
| `exhale` | Exhala despacio | LIBERA LA TENSIÓN | Contracción suave de escala (1.22 a 1.0) |
| `rest` | Pausa en calma | DESCANSA EL CUERPO | Escala en 1.0 en reposo sereno |

---

### 1.2 `BreathingTechnique` (Entity)
Define la estructura inmutable de un ejercicio o patrón de respiración:

```dart
class BreathingTechnique {
  final String id;
  final String name;
  final String description;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int postHoldSeconds;

  const BreathingTechnique({
    required this.id,
    required this.name,
    required this.description,
    required this.inhaleSeconds,
    this.holdSeconds = 0,
    required this.exhaleSeconds,
    this.postHoldSeconds = 0,
  });

  int get cycleDurationSeconds =>
      inhaleSeconds + holdSeconds + exhaleSeconds + postHoldSeconds;
}
```

#### Técnicas Predefinidas (`presets`):
1. **Caja (`box_444`)**: Inhala 4s, Retén 4s, Exhala 4s. Duración ciclo: 12s.
2. **Relajante (`relaxing_478`)**: Inhala 4s, Retén 7s, Exhala 8s. Duración ciclo: 19s.
3. **Serena (`serene_87`)**: Inhala 8s, Retén 0s, Exhala 7s. Duración ciclo: 15s.

---

### 1.3 `BreathingSessionState` (Value Object)
Modelo inmutable del estado en tiempo real de la sesión activa:

```dart
enum SessionStatus { idle, running, paused, completed }

class BreathingSessionState {
  final BreathingTechnique technique;
  final BreathingPhase phase;
  final int phaseSecondsRemaining;
  final int totalSecondsElapsed;
  final int targetTotalSeconds; // 0 indica Modo Libre
  final int currentCycle;
  final int totalCycles;
  final SessionStatus status;

  bool get isFreeMode => targetTotalSeconds <= 0;
  bool get isRunning => status == SessionStatus.running;
  bool get isPaused => status == SessionStatus.paused;
  bool get isCompleted => status == SessionStatus.completed;

  double get sessionProgressFraction {
    if (isFreeMode || targetTotalSeconds == 0) return 0.0;
    return (totalSecondsElapsed / targetTotalSeconds).clamp(0.0, 1.0);
  }

  double get phaseProgressFraction {
    final int phaseTotal = _getPhaseTotalDuration();
    if (phaseTotal <= 0) return 0.0;
    return 1.0 - (phaseSecondsRemaining / phaseTotal).clamp(0.0, 1.0);
  }
}
```

---

### 1.4 `BreathingSessionLog` (Entity)
Registro inmutable para persistir la sesión completada:

```dart
class BreathingSessionLog {
  final String id;
  final String userId;
  final String techniqueId;
  final int durationSeconds;
  final int cyclesCompleted;
  final String dateString; // YYYY-MM-DD
  final int timestampMillis;

  const BreathingSessionLog({
    required this.id,
    required this.userId,
    required this.techniqueId,
    required this.durationSeconds,
    required this.cyclesCompleted,
    required this.dateString,
    required this.timestampMillis,
  });
}
```

---

## 2. DTO & Mapeo de Persistencia (`BreathingSessionModel`)

```dart
class BreathingSessionModel {
  final String id;
  final String userId;
  final String techniqueId;
  final int durationSeconds;
  final int cyclesCompleted;
  final String dateString;
  final int timestampMillis;

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'techniqueId': techniqueId,
    'durationSeconds': durationSeconds,
    'cyclesCompleted': cyclesCompleted,
    'dateString': dateString,
    'timestampMillis': timestampMillis,
  };

  factory BreathingSessionModel.fromMap(Map<String, dynamic> map) => BreathingSessionModel(
    id: map['id'] as String? ?? '',
    userId: map['userId'] as String? ?? '',
    techniqueId: map['techniqueId'] as String? ?? 'box_444',
    durationSeconds: map['durationSeconds'] as int? ?? 0,
    cyclesCompleted: map['cyclesCompleted'] as int? ?? 0,
    dateString: map['dateString'] as String? ?? '',
    timestampMillis: map['timestampMillis'] as int? ?? DateTime.now().millisecondsSinceEpoch,
  );
}
```

---

## 3. Esquema Firestore

```text
users/{userId}/
  ├── breathing_sessions/{sessionId}
  │     ├── id: string ("session_1792873200000")
  │     ├── userId: string ("camila_123")
  │     ├── techniqueId: string ("box_444")
  │     ├── durationSeconds: number (600)
  │     ├── cyclesCompleted: number (12)
  │     ├── dateString: string ("2026-10-24")
  │     └── timestampMillis: number (1792873200000)
```
