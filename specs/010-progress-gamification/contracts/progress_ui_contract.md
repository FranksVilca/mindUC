# UI Contract: 010-progress-gamification

## Overview
Contrato de interfaz y componentes visuales para el panel de progreso y gamificación compasiva de mindUC.

---

## Controller Contract: `IProgressController`

```dart
abstract class IProgressController {
  /// Conmuta o incrementa el avance de una meta amable semanal
  Future<void> toggleIntention(String intentionId);

  /// Recarga el resumen de progreso desde el repositorio
  Future<void> refresh();
}
```

---

## Presentation Widgets Contract

### 1. `ProgressHeader`
- **Responsabilidad**: Barra de navegación superior con botón de retorno, títulos `"MINDUC"` y `"Gamificación Detallada"`, y avatar de usuario.
- **Parámetros**:
  - `required VoidCallback onBack`
  - `VoidCallback? onProfile`

### 2. `GrowthBadgeTitle`
- **Responsabilidad**: Bloque de apertura con insignia píldora `"🌱 Crecimiento consciente"`, título `"Mi Progreso & Florecimiento"` y lema de acompañamiento sereno.

### 3. `ActiveStreakCard`
- **Responsabilidad**: Tarjeta verde pastel de `"RACHA DE AUTOCUIDADO ACTIVO"`, con contador numérico `"7 días consecutivos"`, mensaje de serenidad y franja semanal interactiva `L M X J V S D`.
- **Parámetros**:
  - `required ActiveStreak streak`

### 4. `WeeklyPauseGrid`
- **Responsabilidad**: Cuadrícula de 4 tarjetas con momentos de pausa semanales (respiración, pomodoro, diario y porcentaje de equilibrio).
- **Parámetros**:
  - `required WeeklyPauseMetrics metrics`

### 5. `AchievementsGarden`
- **Responsabilidad**: Sección `"Jardín de logros"` con contador `"3 de 4"` y 4 tarjetas de reconocimientos botánicos con insignias de `"✓ Florecida"` o barra de avance.
- **Parámetros**:
  - `required List<OrganicAchievement> achievements`
  - `required int bloomedCount`
  - `required int totalCount`

### 6. `WeeklyIntentionsCard`
- **Responsabilidad**: Tarjeta interactiva de `"Intenciones de la semana"` con icono de corazón, lista de 3 metas amables y avance reactivo al tocar cada una.
- **Parámetros**:
  - `required List<WeeklyIntention> intentions`
  - `required ValueChanged<String> onToggleIntention`

### 7. `SelfCompassionCard`
- **Responsabilidad**: Tarjeta de cierre compasivo con icono de sol y cita inspiradora (*“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”*).
- **Parámetros**:
  - `required String quote`
  - `required String subtitle`

