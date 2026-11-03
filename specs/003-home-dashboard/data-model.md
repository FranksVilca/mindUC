# Data Model: 003-home-dashboard (Dashboard Principal del Estudiante)

**Feature**: 003-home-dashboard  
**Date**: 2026-11-02  
**Status**: Complete  

---

## 1. Domain Entities & Value Objects

### 1.1 `MoodType` (Enum)
Representa los cinco estados anímicos conscientes capturados en el diseño visual de Figma:

| Valor | Nombre Display | Emoji | Color de Fondo | Icono / Representación |
| :--- | :--- | :--- | :--- | :--- |
| `calma` | Calma | 😌 | `MindColors.autocuidado` (`#E2F0D9`) | Rostro en calma serena |
| `feliz` | Feliz | ✨ | `MindColors.saludMental` (`#FCE4D6`) | Destellos de alegría |
| `ansiosa` | Ansiosa | 🌧️ | `MindColors.productividad` (`#E6E6FA`) | Nube suave de lluvia |
| `cansada` | Cansada | ☕ | `MindColors.accentCalm` (`#F7EBE1`) | Taza humeante reconfortante |
| `energica` | Enérgica | 🌱 | `MindColors.bienestarPill` (`#C8E6C9`) | Brote verde activo |

#### Métodos y Propiedades del Dominio:
- `String get label`: Nombre en español.
- `String get emoji`: Carácter emoji asociado.
- `Color get backgroundColor`: Color pastel de Figma.
- `static MoodType fromString(String value)`: Conversión segura con fallback a `calma`.

---

### 1.2 `MoodEntry` (Entity)
Entidad inmutable que representa el registro diario de pulso emocional del estudiante.

```dart
class MoodEntry {
  final String id;             // Formato: "${userId}_${dateString}"
  final String userId;         // UID del estudiante
  final String dateString;     // Formato ISO local: "YYYY-MM-DD"
  final MoodType mood;         // Tipo de ánimo seleccionado
  final int timestampMillis;   // Época de creación/actualización

  const MoodEntry({
    required this.id,
    required this.userId,
    required this.dateString,
    required this.mood,
    required this.timestampMillis,
  });
}
```

#### Reglas de Validación:
- `userId` no puede estar vacío.
- `dateString` debe coincidir estrictamente con el patrón regex `^\d{4}-\d{2}-\d{2}$`.
- Solo puede existir **una entrada por día por usuario** en Firestore (`users/{userId}/mood_entries/{dateString}`), asegurando que actualizaciones posteriores en el mismo día sobrescriban de forma limpia.

---

### 1.3 `DashboardSummary` (Entity)
Entidad que agrupa los datos necesarios para renderizar el Dashboard de inicio en tiempo real.

```dart
class DashboardSummary {
  final String greetingName;           // Primer nombre ("Camila" o "Estudiante")
  final String formattedDate;          // Ej: "Jueves, 24 de Octubre"
  final MoodType? todayMood;           // Estado de ánimo registrado hoy (null si no ha marcado)
  final int pendingActivitiesCount;    // Ej: 4 actividades pendientes
  final int streakDays;                // Ej: 7 días continuos

  const DashboardSummary({
    required this.greetingName,
    required this.formattedDate,
    this.todayMood,
    this.pendingActivitiesCount = 0,
    this.streakDays = 1,
  });
}
```

---

### 1.4 `QuickAccessItem` (Value Object)
Descriptor inmutable de cada una de las 4 tarjetas de la cuadrícula "Espacios para ti":

```dart
class QuickAccessItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final String targetRoute;

  const QuickAccessItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.targetRoute,
  });
}
```

---

## 2. DTOs & Mapeo de Persistencia (`MoodModel`)

```dart
class MoodModel {
  final String id;
  final String userId;
  final String dateString;
  final String mood;
  final int timestampMillis;

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'dateString': dateString,
    'mood': mood,
    'timestampMillis': timestampMillis,
  };

  factory MoodModel.fromMap(Map<String, dynamic> map) => MoodModel(
    id: map['id'] as String? ?? '',
    userId: map['userId'] as String? ?? '',
    dateString: map['dateString'] as String? ?? '',
    mood: map['mood'] as String? ?? 'calma',
    timestampMillis: map['timestampMillis'] as int? ?? DateTime.now().millisecondsSinceEpoch,
  );

  MoodEntry toDomain() => MoodEntry(
    id: id,
    userId: userId,
    dateString: dateString,
    mood: MoodType.fromString(mood),
    timestampMillis: timestampMillis,
  );
}
```

---

## 3. Esquema Firestore

```text
users/{userId}/
  ├── mood_entries/{YYYY-MM-DD}
  │     ├── id: string ("camila_soto_2026-10-24")
  │     ├── userId: string ("fake_uid_camila_soto")
  │     ├── dateString: string ("2026-10-24")
  │     ├── mood: string ("calma")
  │     └── timestampMillis: number (1792873200000)
```
