# Data Model: 005-wellness-hub

**Feature**: 005-wellness-hub  
**Date**: 2026-11-02  
**Purpose**: Definir las entidades inmutables y modelos de estado para el Hub de Bienestar de mindUC.

---

## 1. Entidades de Dominio

### 1.1 `WellnessSuggestedExercise`

Representa la tarjeta de intervención rápida sugerida para el estudiante según su contexto diario.

| Campo | Tipo | Requerido | Descripción |
| :--- | :--- | :--- | :--- |
| `id` | `String` | Sí | Identificador único del ejercicio sugerido (ej. `suggested_breath_478`). |
| `categoryLabel` | `String` | Sí | Etiqueta de cabecera en mayúsculas (ej. `EJERCICIO SUGERIDO PARA TI HOY`). |
| `title` | `String` | Sí | Título del ejercicio (ej. `Respiración 4–7–8`). |
| `description` | `String` | Sí | Explicación del beneficio (ej. `Técnica antiestrés recomendada para despejar la sobrecarga`). |
| `techniqueId` | `String` | Sí | Clave de técnica asociada (`relaxing_478`). |
| `durationSeconds` | `int` | Sí | Duración en segundos (300 = 5 min). |
| `statusLabel` | `String` | Sí | Texto de estado con indicador (ej. `Ciclo guiado`). |
| `actionLabel` | `String` | Sí | Texto del botón primario de acción (ej. `Comenzar (5 min)`). |

```dart
class WellnessSuggestedExercise {
  final String id;
  final String categoryLabel;
  final String title;
  final String description;
  final String techniqueId;
  final int durationSeconds;
  final String statusLabel;
  final String actionLabel;

  const WellnessSuggestedExercise({
    required this.id,
    required this.categoryLabel,
    required this.title,
    required this.description,
    required this.techniqueId,
    required this.durationSeconds,
    required this.statusLabel,
    required this.actionLabel,
  });

  static const defaultDaily = WellnessSuggestedExercise(
    id: 'suggested_breath_478',
    categoryLabel: 'EJERCICIO SUGERIDO PARA TI HOY',
    title: 'Respiración 4–7–8',
    description: 'Técnica antiestrés recomendada para despejar la sobrecarga',
    techniqueId: 'relaxing_478',
    durationSeconds: 300,
    statusLabel: 'Ciclo guiado',
    actionLabel: 'Comenzar (5 min)',
  );
}
```

---

### 1.2 `WellnessToolItem`

Representa cada una de las 4 herramientas disponibles en la cuadrícula de autocuidado 2x2.

| Campo | Tipo | Requerido | Descripción |
| :--- | :--- | :--- | :--- |
| `id` | `String` | Sí | Clave identificadora (`breathing`, `journal`, `ai_assistant`, `pomodoro`). |
| `title` | `String` | Sí | Nombre principal de la tarjeta. |
| `subtitle` | `String` | Sí | Resumen corto con elocuencia de valor. |
| `badgeText` | `String` | Sí | Insignia superior derecha (`3 min`, `Privado`, `24/7`, `25m`). |
| `icon` | `IconData` | Sí | Icono característico en contenedor circular blanco. |
| `backgroundColor` | `Color` | Sí | Color de fondo pastel botánico oficial. |
| `targetRoute` | `String` | Sí | Ruta GoRouter declarativa de navegación. |
| `isDeferred` | `bool` | No (def: false) | Indica si el módulo está diferido (muestra diálogo compasivo). |

---

### 1.3 `WellnessState`

Estado inmutable administrado por Riverpod para la pantalla `WellnessScreen`.

```dart
class WellnessState {
  final WellnessSuggestedExercise suggestedExercise;
  final List<WellnessToolItem> tools;
  final bool isSanctuaryActive;

  const WellnessState({
    required this.suggestedExercise,
    required this.tools,
    this.isSanctuaryActive = true,
  });

  WellnessState copyWith({
    WellnessSuggestedExercise? suggestedExercise,
    List<WellnessToolItem>? tools,
    bool? isSanctuaryActive,
  }) {
    return WellnessState(
      suggestedExercise: suggestedExercise ?? this.suggestedExercise,
      tools: tools ?? this.tools,
      isSanctuaryActive: isSanctuaryActive ?? this.isSanctuaryActive,
    );
  }
}
```
